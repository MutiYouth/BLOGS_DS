%   Matlad code implementing Chan-Vese model in the paper 'Active Contours Without Edges'
%   This method works well for bimodal images, for example the image 'three.bmp'
%   ----------------------------------------------------------------------------------
%   created on 04/26/2004
%   author: Chunming Li
%   email: li_chunming@hotmail.com
%   Copyright (c) 2004-2006 by Chunming Li
%   Version V1.0
%   Modified by WENG， 2015-1-27
%   hurricanblue@126.com
%   Version V1.1
%   ----------------------------------------------------------------------------------



clear;clc;
% warning off;
Img=imread('15.BMP');         % example that CV model works well
% Img=imread('vessel.bmp');     % example that CV model does NOT work well
% Img=imread('twoCells.bmp');   % example that CV model does NOT work well
% Img=imread('36677.jpg');

U=Img(:,:,1);
I=double(U);
[M,N] =size(U); % get the size
% ic=M/2;
% jc=N/2;
% r=20;
% sdf2circle(nrow,ncol,ic,jc,r);
phi_0 = Img(:,:,1);                                                % PHI_0就是原始图像
phi=phi_0;
figure,imshow(uint8(I),'InitialMagnification','fit');colormap(gray);title('原始图像');  % 设置色图（灰度）
hold on;
plotLevelSet(phi,0,'r');
hold off;


% iteration
lambda_1=1;
lambda_2=1;
delta_t = 0.1;
mu = 0.01*255*255;
nu=0;
h = 1;
epsilon=1;
IterCount = 1;
figure,imshow(uint8(I));colormap gray; hold on;
t_start=cputime;
for k=1:1500,
    % update level set function
    phi=evolution_cv(I, phi, mu, nu, lambda_1, lambda_2, delta_t, epsilon, IterCount);
    if mod(k,10)==0                                         % 模数求余
        pause(.5);
        imshow(uint8(I));colormap gray;
        hold on;
        plotLevelSet(phi,0,'g');
        t_Interval=cputime;
        text(1,M+10,sprintf('Itertion:%4d',k),'BackgroundColor',[.8,.5,.4]);
        text(1,M+40,sprintf('Time Paied:%4.3f',t_Interval-t_start),'BackgroundColor',[.8,.5,.4]);
    end    
end;
hold off;


