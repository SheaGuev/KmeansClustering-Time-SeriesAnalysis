# Wine Quality Analysis Project

## Overview

This project focuses on clustering white wine samples using unsupervised learning techniques in R. The dataset contains 2,700 white wine samples from Portugal, with 11 physicochemical attributes. The primary goal is to group similar wines based on these attributes without using quality ratings. The analysis involves clustering in both the full attribute space and a reduced PCA space to understand the effect of dimensionality reduction on clustering results.

---

## Features

- **Clustering Techniques**: K-means clustering is applied to identify groups of similar wines.
- **Dimensionality Reduction**: Principal Component Analysis (PCA) is used to reduce the dataset's dimensions while retaining at least 85% of the variance.
- **Evaluation Metrics**: Silhouette scores, Calinski-Harabasz index, and BSS/TSS ratios are used to evaluate cluster quality.

---

## Installation

1. Install R and RStudio.
2. Install the required R libraries:
   ```R
   install.packages(c("NbClust", "cluster", "factoextra", "tidyverse", "readxl", "ggplot2", "dplyr", "fpc"))
   ```

---

## Usage

### 1. Data Preprocessing
- Load the dataset:
  ```R
  library(readxl)
  wine_data <- read_excel("Data/Whitewine_v6.xlsx")
  ```
- Randomize and remove outliers using Z-scores:
  ```R
  z_scores <- as.data.frame(scale(wine_data))
  no_outliers <- z_scores[!rowSums(abs(z_scores) > 3.8), ]
  ```

### 2. Determine Optimal Clusters
- Use methods like Elbow Curve, Silhouette, and Gap Statistics:
  ```R
  library(factoextra)
  fviz_nbclust(no_outliers, kmeans, method = 'wss')
  ```

### 3. Perform K-means Clustering
- Apply K-means with $$k=2$$:
  ```R
  kc <- kmeans(no_outliers[, -length(no_outliers)], centers = 2)
  ```

### 4. PCA and Clustering
- Reduce dimensions using PCA:
  ```R
  pca_wine <- prcomp(no_outliers[, -length(no_outliers)], center = TRUE)
  ```
- Perform clustering on transformed data:
  ```R
  kmeans_pca <- kmeans(as.data.frame(-pca_wine$x[,1:7]), centers = 2)
  ```

---

## Results

| Method          | BSS/TSS Ratio | Avg. Silhouette Width | CH Index |
|------------------|---------------|------------------------|----------|
| Full Dataset     | 0.239         | 0.21                  | 820      |
| PCA Transformed  | 0.267         | 0.25                  | 949      |

- PCA improved cluster separation slightly but clusters remain moderately defined.

---

## Conclusion

This analysis demonstrated that clustering white wine samples based on physicochemical properties can reveal patterns in the data. While PCA improved cluster definition marginally, further refinement or alternative clustering methods may be needed for better separation.

---

## Appendix: Full R Code

The full R code used for this project is available in the attached documentation or can be accessed in the `scripts/` folder of this repository.

Citations:
[1] https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/13497718/015965df-622c-477f-8cf0-257e711dd860/Wine-Quality-Analysis-Report.pdf
[2] https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/13497718/a58b1bea-0f14-4724-86f5-bfe133ef96e1/Time-Series-Forecasting-Report.docx
