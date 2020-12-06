% This Matlab file demomstrates a level set method in the following paper
%    C. Li, C. Xu, C. Gui, and M. D. Fox "Level Set Evolution Without Re-initialization: A New Variational Formulation"
%    in Proc. IEEE Conf. Computer Vision and Pattern Recognition (CVPR'05), vol. 1, pp. 430?36, 2005.
%
% Author: Chunming Li, all rights reserved.
% E-mail: li_chunming@hotmail.com
% URL:  http://vuiis.vanderbilt.edu/~licm/
% Reviewed by WENG, 2015.1.29 Bir. 1041


clear all;
close all;
Img = imread('twoObj.bmp');
Img=double(Img(:,:,1));
sigma=1.5;                          % scale parameter in Gaussian kernel for smoothing.
G=fspecial('gaussian',15,sigma);
Img_smooth=conv2(Img,G,'same');     % smooth image by Gaussiin convolution
[Ix,Iy]=gradient(Img_smooth);
f=Ix.^2+Iy.^2;
% edge indicator function.
g=1./(1+f);
% the papramater in the definition of smoothed Dirac function
epsilon=1.5;
% time step
% Note: the product timestep*mu must be less than 0.25 for stability!
timestep=5;
% coefficient of the internal (penalizing) energy term P(\phi)
mu=0.2/timestep;
% coefficient of the weighted length term Lg(\phi)
lambda=5;
% coefficient of the weighted area term Ag(\phi);
% Note: Choose a positive(negative) alf if the initial contour is outside(inside) the object.
alf=1.5;

% define initial level set function (LSF) as -c0, 0, c0 at points outside, on
% the boundary, and inside of a region R, respectively.
c0=4;
w=8;
[nrow, ncol]=size(Img);
initialLSF=c0*ones(nrow,ncol);
% zero level set is on the boundary of R.
% Note: this can be commented out. The intial LSF does NOT necessarily need a zero level set.
initialLSF(w+1:end-w, w+1:end-w)=0; 
% negative constant -c0 inside of R, postive constant c0 outside of R.
initialLSF(w+2:end-w-1, w+2: end-w-1)=-c0;
u=initialLSF;
figure;imagesc(Img);colormap(gray);axis off;hold on;
contour(u,[0 0],'g');
title('Initial contour');

% start level set evolution
IteriationNumber=500;
for n=1:IteriationNumber
    u=EVOLUTION(u, g ,lambda, mu, alf, epsilon, timestep, 1);
    if mod(n,20)==0
        pause(0.001);
        imagesc(Img);colormap(gray);axis off;hold on;
        [c,h] = contour(u,[0 0],'r'); %#ok<*ASGLU,*NASGU>
        % clabel(c, h); colorbar;
        iterNum=[num2str(n), ' iterations'];
        title(iterNum);
        hold off;
    end
end
imagesc(Img);colormap(gray);axis off;hold on;
[c,h] = contour(u,[0 0],'r');
totalIterNum=[num2str(n), ' iterations'];
title(['Final contour, ', totalIterNum]);
