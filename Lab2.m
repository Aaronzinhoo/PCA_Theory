%Aaron Gonzales
%%
load image3;
figure
imshow(image3,[])
rot = linspace(0,180,200);
imgs=zeros(200,61,61);
img_vec = zeros(200,61*61);
%%
%1 generate the data and rotate 200 images up to 180 degrees
for i=1:200
    Rot_img = imrotate(image3,rot(i), 'crop');
    %imshow(Rot_img)
    imgs(i,:,:)=Rot_img;
    img_vec(i,:) = reshape(imgs(i,:,:),1,61*61);
end

%2 Calculate the mean, covarience matrix and compute the eigenvals and  
img_vec = img_vec';
sample_mean = mean(img_vec,2);
Covar = cov(img_vec');
[eig_vec, eig_val] = eigs(Covar,50);
eig_vals = diag(eig_val);

%3. Since the eigenvalue tells us how much varience it accounts for we only
%have to compute the eigenvalues with larger values. The smaller the value,
%the less they explain the data. Now if N < D and we have a matrix that is
%DxN then the rank can be at most N-1 therefore calculating any eigenvalues
%beyond this point would be unecessary as they dont help explain our data 
%%
%4 Display PCs
% PCs are the col of XX' he cov matrix
figure
for i=1:8
    subplot(2,4,i); 
    imshow(mat2gray(reshape(eig_vec(:,i),61,61)))
    title([num2str(i), ' PC'])
end

%4. The PCs are composed of mainly zeros except for its values near the
%center. This helps because we can tell the PCs are picking up on the
%varience of images in the dataset. It displays something similar to circle
%since we have data composed of rotated threes this also makes sense. The
%first PC does not seem to swirl as much as the other PCs after it. The
%more PCs you plot the more the image seems to be twisting in the middle.

%5.
figure
plot(eig_vals, '.-','MarkerSize', 8)
xlabel('Eigenvalue i');
ylabel('Eigenvalue');
title('Eigenvalue Plot')

%the eigenvalues show a sharp decline at around 20. This leads me to
%believe that the dimensionality of the data is around there since this is
%where most of the varience is explained. The most independent eigenvectors
%are the ones that have higher lambda values so when we see a sharp decline
%in lambda gives us an appropriate cut-off point
%%
%6 compute reconstruction of image
PCA_img = zeros(20,61,61);

i=0;
for j=2:2:20
    i=i+1;
    S = zeros(3721,1);
    for k=1:j
        sum = (eig_vec(:,k)'*(img_vec(:,1)-sample_mean))*eig_vec(:,k);
        S = S + sum;
    end
    PCA_img = sample_mean + S;
    subplot(2,5,i); 
    imshow(reshape(PCA_img,61,61))
    title([num2str(j), ' PCs 180*'])
end

%6. Compared to the previous prediction the actual value that seemed to
%best fit the original picture was K=15 or 20 anything after we cannot see
%a noticable difference in the image, and before is too blurry.

%%
%7. woorking with degree up to 360
rot = linspace(0,360,200);
img_vec = zeros(200,61*61);
for i=1:200
    Rot_img = imrotate(image3,rot(i), 'crop');
    imgs(i,:,:)=Rot_img;
    img_vec(i,:) = reshape(imgs(i,:,:),1,61*61);
end

img_vec = img_vec';
sample_mean = mean(img_vec,2);
Covar = cov(img_vec');
[eig_vec, eig_val] = eigs(Covar,50);
eig_vals = diag(eig_val);

i=0;
for j=1:2:20
    i=i+1;
    S = zeros(3721,1);
    for k=1:j
        sum = (eig_vec(:,k)'*(img_vec(:,1)-sample_mean))*eig_vec(:,k);
        S = S + sum;
    end
    PCA_img = sample_mean + S;
    subplot(2,5,i); 
    imshow(reshape(PCA_img,61,61))
    title([num2str(j), ' PCs 360*'])
end
figure
for i=1:8
    subplot(2,4,i); 
    imshow(mat2gray(reshape(eig_vec(:,i),61,61)))
    title([num2str(i), ' PC'])
end
figure
plot(eig_vals, '.-','MarkerSize', 8)
xlabel('Eigenvalue i');
ylabel('Eigenvalue');
title('Eigenvalue Plot')
%The curve that we use to determine the right amount e_vecs to use is much more
%spicky than before and seems to have the cut off point at a little below
%where it was for the previous section. Each PC seems more complex, but not
%as much as the previous time we ran it at 180 degrees. You can immediately
%see th difference when contrasting the first 2 PCs of both sections. The
%previous section becomes more complex looking at a faster rate. The
%recalculated image seems to follow the same pattern as before with the
%10,11,12,13 and beyond being where we stop to see noticable differences

%%
%8. Explain why choosing two vectors that best represent the conanonical basis
% is not suitable here and use a scatter plot to display them

E = eye(3721);
num = floor(3721/2);
feature = zeros(200,3);
for i = num:num+2
    feature(:,i+1-num) = img_vec'*E(:,i);
end

figure
subplot(1,2,1);scatter(feature(:,1), feature(:,2))
xlabel('1st feature');
ylabel('2nd feature');
title(sprintf('2-D Scatter Plot of features %d,%d',num,num+1))
subplot(1,2,2);scatter3(feature(:,1), feature(:,2), feature(:,3))
xlabel('1st feature');
ylabel('2nd feature');
zlabel('3rd feature');
title(sprintf('3-D Scatter Plot of features %d, %d, %d', num,num+1,num+2))

%8.
%The reason this is not suitable is because our data is sparse we are not
%collecting that much information off of any of the features really. 
%Our data is pixels so we are just getting the certain pixels. Had we had a
%more condesed shape this could be avoided possibly. The plots currently 
%though dont account for much. One thing to note is though that we see a
%more complex plot when in 3 dimensions rather than 2

%% 
%9. Choose two or three good PCA score vectors to display on scatter plot
PCA_scores=zeros(200,3);
for i=1:3
    PCA_scores(:,i) = (img_vec')*eig_vec(:,i);
end
figure
subplot(1,2,1);scatter(PCA_scores(:,1), PCA_scores(:,2))
xlabel('1st PC');
ylabel('2nd PC');
title('2-D Scatter Plot of PC score')
subplot(1,2,2);scatter3(PCA_scores(:,1), PCA_scores(:,2), PCA_scores(:,3))
xlabel('1st PC');
ylabel('2nd PC');
zlabel('3rd PC');
title('3-D Scatter Plot of PC score')


%For the plot of two PC scores out scatter plot resembles the shape similar to a
%circle. Meaning this is the best representation of our data using only up
%two PCs when recreating the data. The next scatter plot includes an extra
%PC and makes the representation of the data a lot more complex compared to
%when using only two. The data now resembles that of a saddle making use of
%3 dimensions. 

%10
%The intrinsic dimensionality of the data is 1 because we can only account
%for the rotation that we created. The amount of componets needed is a little 
%more than 3 because of the fact that we have noise added to the data, i.e. 
%the rotations. This accounts for why we must choose more PCs than the 
%intrinsic dimensionality

%