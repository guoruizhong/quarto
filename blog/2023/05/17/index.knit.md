---
title: "Perform Principal Component Analysis"
date: 2023-05-17
# date-modified: 2023-04-05
categories:
  - PCA
image: p.png
---



![](pca.png)

Principle component methods are used to summarize and viusalize the information contained in a large multivariate datasets.

Principle component analysis is used to extract the important information from a multivariate data table and to express this information as a set of few new variables called principle components. These new variables correspond to a linear combination of the originals. The number of principal components is less than or equal to the number of original variables.

PCA assumes that the directions with the largest variances are the most “important” (i.e, the most principal).

Technically speaking, the amount of variance retained by each principal component is measured by the so-called eigenvalue.

Note that, the PCA method is particularly useful when the variables within the data set are highly correlated. Correlation indicates that there is redundancy in the data. Due to this redundancy, PCA can be used to reduce the original variables into a smaller number of new variables ( = principal components) explaining most of the variance in the original variables.



Taken together, the main purpose of principal component analysis is to:

  - identify hidden pattern in a data set,
  - reduce the dimensionnality of the data by removing the noise and redundancy in the data,
  - identify correlated variables

![](pca2.png)

## Compute PCA












