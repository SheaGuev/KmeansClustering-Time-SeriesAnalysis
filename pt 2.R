install.packages("neuralnet")
install.packages("grid")
install.packages("MASS")
install.packages("readxl")
install.packages("caret")


library(neuralnet)
library(readxl)
library(grid)
library(MASS)
library(caret)


################
#load data

financial = read_excel("ExchangeUSD.xlsx")
head(financial)
View(financial)

#selecting the usd/eur price column
eu_usd = financial$`USD/EUR`
eu_usd

summary(eu_usd)

##normalising the dataset NOTE: SCALING ENTIRE DATA BEFORE SPLITTING CAUSES DATA LEAKAGE
# eu_usd = scale(eu_usd)
# summary(eu_usd)
# View(eu_usd)

## Splitting the data set into a test and train
data_train = eu_usd[1:400]
data_test = eu_usd[401:500]


# #Convert to dataframe for comformality purposes 
# data_train_df <- data.frame(price = data_train)
# data_test_df <- data.frame(price = data_test)
# ##DO THIS TO PREVENT SKEWED NORMALISATION IN THE TRAINING AND TESTING PHASE!!
# 
# norm_fit = preProcess(data_train_df, method = "range")
# norm_dt = predict(norm_fit, data_train_df)#data_train
# norm_td = predict(norm_fit, data_test_df) #data_test


tmax = max(data_train)
tmin = min(data_train)
tmax
tmin

normalise <- function(x) {
  return((x - tmin) / (tmax - tmin))
}

norm_dt = normalise(data_train)
norm_td = normalise(data_test)




########################################

##CREATE LAGGED INPUTS FOR TIME-SERIES ANALYSIS

lagged_matrix_inputs = function(data, lags) {
  no_lags = length(lags)
  no_rows = length(data) - max(lags) 
  
  input_matrix=matrix(0, nrow = no_rows, ncol = no_lags)
  
  for (i in 1:no_rows) {
    for (j in 1:no_lags) {
      input_matrix[i, j] = data[i + lags[j] - 1]
    }
  }
  return(input_matrix)
}

# #TESTING Creating the I/O matrices

 # lags = 1:6
 # train_inputs <- lagged_matrix_inputs(norm_dt, lags)
 # View(norm_dt)
 # class(norm_dt)
 # length(norm_dt)
# 
# train_inputs <- lagged_matrix_inputs(data_train, lags)
# test_inputs <- lagged_matrix_inputs(data_train, lags)
# training_outputs = data_train[(max(lags)+1):length(data_train)]
# testing_outputs = data_test[(max(lags)+1):length(data_test)]
# 
# View(train_inputs)
# training_outputs
# dim(train_inputs)
# dim(training_outputs)



# Function to train and evaluate MLP
train_mlp <- function(n_lags, n_hidden, act_fun, lin_out) {
  # Create lagged inputs 
  lags <- 1:n_lags
  train_inputs <- lagged_matrix_inputs(norm_dt, lags)
  test_inputs <- lagged_matrix_inputs(norm_td, lags)
  training_outputs = norm_dt[(max(lags)+1):length(norm_dt)]
  testing_outputs = norm_td[(max(lags)+1):length(norm_td)]
  

  
  # Convert training_outputs to a matrix with a single column
  training_outputs <- as.matrix(training_outputs)
  
  # Create a data frame combining train_inputs and training_outputs
  train_data <- cbind(train_inputs, training_outputs)
  colnames(train_data) <- c(paste0("input", 1:ncol(train_inputs)), "output")

  # dim1 = length(training_outputs)
  # dim2 = dim(train_inputs)
  # #
  # class1 = class(train_outputs_norm)
  # class2 = class(train_inputs_norm)
  # 
  # dim(train_inputs_norm)
  # train_outputs_norm
  # train_inputs_norm
  # 
  #  return(c(dim1, dim2, class1, class2)) ##Error handling arrays not comformable
  
   #return(dim(train_inputs))
  
  
  
  
  #Train MLP
  mlp_model <- neuralnet(output ~ .,
                         data = train_data,
                         hidden = n_hidden,
                         act.fct = act_fun,
                         linear.output = lin_out)


  # Evaluate on test set
  test_preds <- compute(mlp_model, test_inputs)$net.result
  

  # De-normalize predictions
  test_preds <- test_preds*(tmax - tmin) + tmin
  
  test_dn <- testing_outputs*(tmax - tmin) + tmin
  
  #return(cbind(test_preds, test_dn))

  # Calculate metrics
  rmse <- sqrt(mean((test_preds - testing_outputs)^2))
  mae <- mean(abs(test_preds - testing_outputs))
  mape <- mean(abs((test_preds - testing_outputs)/testing_outputs))*100
  smape <- (1/length(testing_outputs))*sum(2*abs(test_preds - testing_outputs)/(abs(test_preds) + abs(testing_outputs)))*100

  return(c(rmse, mae, mape, smape))
}

mlp_result = train_mlp(4, 6, "logistic", TRUE)
View(mlp_result)

testing_output = mlp_result[, 2]
pred = mlp_result[, 1]

y_min <- min(c(testing_output, pred))
y_max <- max(c(testing_output, pred))

x = 1:length(testing_output)
plot(x, testing_output, col = "red", type = "l", lwd=2,
     main = " prediction", ylim = c(y_min, y_max))
lines(x, pred, col = "blue", lwd=2)
legend("topright",  legend = c("original-price", "predicted-price"), 
       fill = c("red", "blue"), col = 2:3,  adj = c(0, 0.6))
grid() 



# Train multiple models
mlp_results <- data.frame(matrix(nrow = 12, ncol = 6))
colnames(mlp_results) <- c("Structure", "RMSE", "MAE", "MAPE", "SMAPE", "Description")

mlp_results[1,] <- c("MLP1", train_mlp(4, 5, "logistic", FALSE), "4 lags, 1 Hidden, 5 Neurons, Logistic, non-linear")
mlp_results[2,] <- c("MLP2", train_mlp(4, 10, "logistic", TRUE), "4 lags, 1 Hidden, 10 Neurons, Logistic, linear")
mlp_results[3,] <- c("MLP3", train_mlp(4, 5, "tanh", FALSE), "4 lags, 1 Hidden, 5 Neurons, TanH, non-linear")
mlp_results[4,] <- c("MLP4", train_mlp(4, 10, "tanh", TRUE), "4 lags, 1 Hidden, 10 Neurons, TanH, linear")
mlp_results[5,] <- c("MLP5", train_mlp(3, c(5,3), "logistic", TRUE), "3 lags, 2 Hidden, 5-3 Neurons, Logistic, linear")
mlp_results[6,] <- c("MLP6", train_mlp(3, c(8,5), "logistic", FALSE), "3 lags, 2 Hidden, 8-5 Neurons, Logistic, non-linear") 
mlp_results[7,] <- c("MLP7", train_mlp(3, c(5,3), "tanh", TRUE), "3 lags, 2 Hidden, 8-5 Neurons, TanH, linear")
mlp_results[8,] <- c("MLP8", train_mlp(3, c(5,3), "tanh", FALSE), "3 lags, 2 Hidden, 5-3 Neurons, TanH, non-linear")
mlp_results[9,] <- c("MLP9", train_mlp(4, 6, "logistic", TRUE), "4 lags, 1 Hidden, 6 Neurons, Logistic, linear")
mlp_results[10,] <- c("MLP10", train_mlp(4, 8, "tanh", TRUE), "4 lags, 1 Hidden, 8 Neurons, TanH, linear")
mlp_results[11,] <- c("MLP11", train_mlp(4, c(6,4), "logistic", FALSE), "4 lags, 2 Hidden, 6-4 Neurons, Logistic, non-linear")
mlp_results[12,] <- c("MLP12", train_mlp(4, c(8,6), "tanh", FALSE), "4 lags, 2 Hidden, 8-6 Neurons, TanH, non-linear")


View(mlp_results)

