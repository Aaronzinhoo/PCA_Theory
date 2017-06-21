# PCA Theory
A theoretical perspective to PCA and how to manually apply it to images.

A simple implementation of PCA. We first create a set of images by iteratively rotating an image. We compute the covariance matrix 
and get the eigenvalues and vectors resp. in decreasing order. With this, we can visualize the principal components and how they describe the space the data lies on intrinsically. Examining the eigenvalues and their rate of decrease provides us with the amount of eigenvectors needed to recreate the image. This process is completed 2x for images rotated up to 180 degrees adn then again up to 360 degrees.  
