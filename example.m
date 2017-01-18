close all;

inputImage = imread('101_5.tif');
outputImage = shock_filter(inputImage,sigma,rho,15);

imshow(inputImage);
figure;
imshow(outputImage/255);