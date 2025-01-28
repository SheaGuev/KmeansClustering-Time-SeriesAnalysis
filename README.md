## Detailed Results and Techniques Used in Wine Clustering Project

### Techniques Employed

1. **K-Means Clustering**:
   - K-means is an unsupervised learning algorithm that partitions data into $$k$$ clusters by minimizing the within-cluster sum of squares (WCSS). The centroids are iteratively updated until convergence or minimal WCSS is achieved.
   - The optimal number of clusters ($$k$$) was determined using methods like the Elbow Method, Silhouette Score, and Calinski-Harabasz Index[1][2][7].

2. **Principal Component Analysis (PCA)**:
   - PCA was used for dimensionality reduction, transforming the dataset into a lower-dimensional space while retaining at least 85% of the variance. This reduces noise and computational complexity while preserving key patterns in the data[2][4].
   - The first few principal components explained most of the variance, allowing clustering to be performed on a reduced feature set[5][7].

3. **Evaluation Metrics**:
   - **Silhouette Score**: Measures how well-separated clusters are by comparing intra-cluster cohesion and inter-cluster separation.
   - **Calinski-Harabasz Index**: Evaluates cluster compactness and separation.
   - **BSS/TSS Ratio**: Indicates the proportion of variance explained by the clustering[6][7].

---

### Results Summary

#### 1. Clustering on Full Dataset
- **Optimal Number of Clusters**: Determined to be 2 using the Elbow Method and Silhouette Analysis.
- **Cluster Quality Metrics**:
  - **BSS/TSS Ratio**: 0.239, indicating a moderate amount of variance explained by the clustering.
  - **Average Silhouette Width**: 0.21, suggesting weakly defined clusters.
  - **Calinski-Harabasz Index**: 820, reflecting moderate cluster separation.

#### 2. Clustering on PCA-Reduced Dataset
- **Dimensionality Reduction**:
  - The first seven principal components retained over 85% of the variance.
- **Cluster Quality Metrics**:
  - **BSS/TSS Ratio**: Improved to 0.267, showing slightly better cluster separation compared to the full dataset.
  - **Average Silhouette Width**: Increased to 0.25, indicating marginally better-defined clusters.
  - **Calinski-Harabasz Index**: Increased to 949, demonstrating improved compactness and separation.

#### Observations
- PCA reduced noise and improved clustering performance slightly, as evidenced by higher evaluation scores across all metrics.
- Despite improvements with PCA, the clusters remained moderately defined, suggesting that additional preprocessing or alternative clustering methods (e.g., Gaussian Mixture Models) might yield better results[2][4][6].

---

### Visualizations
1. **Elbow Curve**:
   - Showed a clear "elbow" at $$k=2$$, supporting this as the optimal number of clusters.

2. **PCA Scatter Plot**:
   - Visualized clusters along the first two principal components (PCA1 and PCA2). While some separation was evident, significant overlap remained between clusters.

3. **Silhouette Plot**:
   - Highlighted that many samples were close to decision boundaries, reflecting weak intra-cluster cohesion.

---

### Conclusion
The analysis demonstrated that clustering white wine samples based on physicochemical properties is feasible but challenging due to overlapping attribute distributions. PCA improved cluster quality metrics slightly but did not fully resolve ambiguities in cluster assignments. Future work could explore advanced techniques such as hierarchical clustering or Expectation-Maximization with Gaussian Mixture Models for potentially better results[4][6].

Citations:
[1] https://www.geeksforgeeks.org/kmeans-clustering-and-pca-on-wine-dataset/
[2] https://github.com/vincent27hugh/Cluster-Kmeans-EMGMM-PCA
[3] https://drpress.org/ojs/index.php/HSET/article/view/12065
[4] https://louis-dr.github.io/machinel3.html
[5] https://www.kaggle.com/code/annavidiella/wine-clustering-with-k-means-pca
[6] https://bpb-us-w2.wpmucdn.com/sites.umassd.edu/dist/e/1274/files/2022/12/HW5.pdf
[7] https://www.kdnuggets.com/2023/04/exploring-unsupervised-learning-metrics.html
[8] https://www.kaggle.com/code/georgehanyfouad/wine-clustering-with-k-means-and-dbscan-and-pca/input
[9] https://uca.edu/cse/files/2020/02/Wine-Informatics-Clustering-and-Analysis-of-Professional-Wine-Reviews.pdf
[10] https://core.ac.uk/download/pdf/228084466.pdf
