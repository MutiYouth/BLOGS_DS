% This Matlab file demomstrates a level set method in the following paper
%    C. Li, C. Xu, C. Gui, and M. D. Fox "Level Set Evolution Without Re-initialization: A New Variational Formulation"
%    in Proc. IEEE Conf. Computer Vision and Pattern Recognition (CVPR'05), vol. 1, pp. 430–436, 2005.
%
% Author: Chunming Li, all rights reserved.
% E-mail: li_chunming@hotmail.com
% URL:  http://vuiis.vanderbilt.edu/~licm/

clear all;
close all;
Img = imread('twocells.bmp');  % The same cell image in the paper is used here
Img=double(Img(:,:,1));
sigma=1.5;    % scale parameter in Gaussian kernel for smoothing.
G=fspecial('gaussian',15,sigma);
Img_smooth=conv2(Img,G,'same');  % smooth image by Gaussiin convolution
[Ix,Iy]=gradient(Img_smooth);
f=Ix.^2+Iy.^2;
g=1./(1+f);  % edge indicator function.

epsilon=1.5; % the papramater in the definition of smoothed Dirac function

timestep=5;  % time step, try timestep=10, 20, ..., 50, ...
mu=0.2/timestep;  % coefficient of the internal (penalizing) energy term P(\phi)
          % Note: the product timestep*mu must be less than 0.25 for stability!

lambda=5; % coefficient of the weighted length term Lg(\phi)
alf=1.5;   % coefficient of the weighted area term Ag(\phi);
           % Note: Choose a positive(negative) alf if the initial contour is outside(inside) the object.
           
[nrow, ncol]=size(Img);
figure;imagesc(Img, [0, 255]);colormap(gray);hold on;
text(6,6,'Left click to get points, right click to get end point','FontSize',[12],'Color', 'r');

% Click mouse to specify initial contour/region
BW = roipoly;  % get a region R inside a polygon, BW is a binary image with 1 and 0 inside or outside the polygon;
c0=4; % the constant value used to define binary level set function;
initialLSF= c0*2*(0.5-BW); % initial level set function: -c0 inside R, c0 outside R;
u=initialLSF;

[c,h] = contour(u,[0 0],'r');
u=initialLSF;
figure;imagesc(Img, [0, 255]);colormap(gray);hold on;
[c,h] = contour(u,[0 0],'r');                          
title('Initial contour');

% start level set evolution
for n=1:300
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
title(totalIterNum);
