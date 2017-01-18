function inputImage=shock_filter(inputImage,sigma,rho, iter)
% Implementation of Weickert's [1] paper.
%inputImage: Input image to be considered by coherence-enhancing shock
% filter
% sigma: Standard deviation of Gaussian filter for image. Often sigma is chosen in
%the range between 0.5 and 2 pixel units
% rho: Standard deviation of Gaussian filter for structure tensor
% iter : Number of iterations

%[1] Weickert, Joachim. "Coherence-enhancing shock filters."Joint
%Pattern Recognition Symposium. Springer Berlin Heidelberg, 2003.
if nargin < 4
    sigma = 2;
    rho = 0.5;
    iter = 15;
end
if size(inputImage,3) == 3
    inputImage = rgb2gray(inputImage);
end
inputImage = double(inputImage);
v = imgaussfilt(inputImage,sigma);

ut = zeros(size(inputImage));
for j = 1:iter
[ux, uy] = gradient(inputImage);

[vx,vy] = gradient(v);
[vxx,vxy] = gradient(vx);
[~,vyy] = gradient(vy);

Jxx = imgaussfilt(ux.^2,rho);
Jxy = imgaussfilt(ux.*uy,rho);
Jyy = imgaussfilt(uy.*uy,rho);
    for i=1:numel(inputImage)
        S = [Jxx(i) Jxy(i);Jxy(i) Jyy(i)];
        [eigenvector,~] = eig(S);
        w = eigenvector(:,2)/norm(eigenvector);
        ut(i) = -sign(vxx(i)*w(1)*w(1)+ vxy(i)*w(1)*w(2) + vyy(i) *w(2) *w(2));
    end
    ut = ut.*sqrt(ux.^2+uy.^2);
    
    inputImage = inputImage + ut;
end