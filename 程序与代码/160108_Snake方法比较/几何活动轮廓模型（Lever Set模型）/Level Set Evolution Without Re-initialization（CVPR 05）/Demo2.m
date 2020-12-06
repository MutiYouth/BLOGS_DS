% This Matlab file demomstrates a level set method in the following paper
%    C. Li, C. Xu, C. Gui, and M. D. Fox "Level Set Evolution Without Re-initialization: A New Variational Formulation"
%    in Proc. IEEE Conf. Computer Vision and Pattern Recognition (CVPR'05), vol. 1, pp. 430–436, 2005.
%
% Author: Chunming Li, all rights reserved.
% E-mail: li_chunming@hotmail.com
% URL:  http://vuiis.vanderbilt.edu/~licm/

clear all;
close all;
Img = imread('twoObj.bmp');  % synthetic noisy image
Img=double(Img(:,:,1));
sigma=1.5;    % scale parameter in Gaussian kernel for smoothing
G=fspecial('gaussian',15,sigma);
Img_smooth=conv2(Img,G,'same');  % smooth image by Gaussiin convolution
[Ix,Iy]=gradient(Img_smooth);
f=Ix.^2+Iy.^2;
g=1./(1+f);  % edge indicator function.

epsilon=1.5; % the papramater in the definition of smoothed Dirac function

timestep=5;  % time step
mu=0.2/timestep;  % coefficient of the internal (penalizing) energy term P(\phi)
          % Note: the product timestep*mu must be less than 0.25 for stability!

lambda=5; % coefficient of the weighted length term Lg(\phi)
alf=3;   % coefficient of the weighted area term Ag(\phi);
         % Note: Choose a positive(negative) alf if the initial contour is outside(inside) the object.

% define initial level set function (LSF) as -c0, 0, c0 at points outside, on
% the boundary, and inside of a region R, respectively.
[nrow, ncol]=size(Img);  
c0=4;
initialLSF=c0*ones(nrow,ncol);
w=8;
initialLSF(w+1:end-w, w+1:end-w)=0;  % zero level set is on the boundary of R. 
                                     % Note: this can be commented out. The intial LSF does NOT necessarily need a zero level set.
                                     
initialLSF(w+2:end-w-1, w+2: end-w-1)=-c0; % negative constant -c0 inside of R, postive constant c0 outside of R.
u=initialLSF;
figure;imagesc(Img, [0, 255]);colormap(gray);hold on;
[c,h] = contour(u,[0 0],'r');                          
title('Initial contour');


% start level set evolution
for n=1:250
    u=EVOLUTION(u, g ,lambda, mu, alf, epsilon, timestep, 1);      
    if mod(n,20)==0
        pause(0.001);
        imagesc(Img, [0, 255]);colormap(gray);hold on;
        [c,h] = contour(u,[0 0],'r'); 
        iterNum=[num2str(n), ' iterations'];        
        title(iterNum);
        hold off;
    end
end
imagesc(Img, [0, 255]);colormap(gray);hold on;
[c,h] = contour(u,[0 0],'r'); 
totalIterNum=[num2str(n), ' iterations'];  
title(['Final contour, ', totalIterNum]);
