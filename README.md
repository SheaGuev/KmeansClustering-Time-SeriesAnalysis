# KmeansClustering-Time-SeriesAnalysis
Kmeans analysis report with a time-series forecasting MLP NN


# Overview
This coursework is part of the Machine Learning & Data Mining module at the University of Westminster, designed for the academic year 2023-2024. The coursework is divided into two main parts: Partitioning Clustering and Financial Forecasting, each focusing on different aspects of machine learning and data analysis using R programming.
# Part 1: Partitioning Clustering
# Objective
The first part of the coursework involves clustering analysis using a dataset of white wine samples. The dataset includes various physicochemical properties of the wine, such as acidity, sugar content, and alcohol level. The primary goal is to cluster these wines based on their chemical properties, excluding the quality rating provided by human tasters.
# Methodology
Data Preprocessing: Includes scaling and outlier detection/removal to prepare the dataset for clustering.
Determining Number of Clusters: Utilizes methods like the Elbow method, Silhouette method, and Gap statistic to determine the optimal number of clusters.
K-Means Clustering: Implementation of k-means clustering to group the wines into clusters based on their properties.
Evaluation: The clusters are evaluated using metrics like the silhouette score and the Calinski-Harabasz index.
# Code Implementation
The R code provided performs all the steps from data preprocessing to clustering and evaluation. It includes functions for reading the data, preprocessing, applying k-means, and calculating evaluation metrics.
# Part 2: Financial Forecasting
# Objective
The second part focuses on forecasting the exchange rate between the USD and the Euro using a multilayer perceptron neural network (MLP-NN). The dataset contains daily exchange rates over a specified period.
# Methodology
Data Preparation: Involves normalizing the data and creating input/output matrices for the neural network.
MLP Neural Network: A neural network is trained to predict future exchange rates based on historical data.
Evaluation: The model's performance is assessed using statistical metrics like RMSE (Root Mean Squared Error) and MAE (Mean Absolute Error).
# Code Implementation
The provided R code includes detailed steps for preparing the data, training the MLP model, and evaluating its performance. It uses the neuralnet package in R for modeling.
# Reports and Analysis
Each part of the coursework includes a detailed report that discusses the methodologies used, the results obtained, and the implications of these results. The reports also include visualizations such as plots of clustered data and performance metrics of the forecasting model.
