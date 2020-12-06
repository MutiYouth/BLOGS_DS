% EXAMPLE     GVF snake examples on two simulated object boundaries.
%
% NOTE:
%
% traditional snake and distance snake differed from GVF snake only
%   by using different external force field. In order to produce the
%   corresponding external force field, use the following (all
%   assuming edge map f is in memory).
%
% traditional snake:
%   f0 = gaussianBlur(f,1);
%   [px,py] = gradient(f0);
%
% distance snake:
%   D = dt(f>0.5);  % distance transform (dt) require binary edge map
%   [px,py] = gradient(-D);
%
% [px,py] is the external force field in both cases
%
% balloon model using a different matlab function "snakedeform2"
% instead of "snakedeform". The external force could be any force
% field generated above.
%
% an example of using it is as follows
%       [x,y] = snakedeform2(x,y, alpha, beta, gamma, kappa, kappap, px,py,2);
% do a "help snakedeform2" for more details
%

%   Chenyang Xu and Jerry Prince 6/17/97
%   Copyright (c) 1996-97 by Chenyang Xu and Jerry Prince


% ==== Example 1: U-shape object ====

% Read in the 64x64 U-shape image
clc;clear;
[I,~] = rawread('../images/Milan-test.pgm');

% I = 255 - 255  * edge(imread('bar.bmp'), 'sobel');

% Compute its edge map
disp(' Compute edge map ...');
f = 1 - I/255;

% Compute the GVF of the edge map f
disp(' Compute GVF ...');
[u,v] = GVF(f, 0.2, 80);
disp(' Nomalizing the GVF external force ...');
mag = sqrt(u.*u+v.*v);
px = u./(mag+1e-10); py = v./(mag+1e-10);

% display the results
figure(1);
subplot(221); imdisp(I); title('test image');
subplot(222); imdisp(f); title('edge map');

% display the gradient of the edge map
[fx,fy] = gradient(f);
subplot(223); quiver(fx,fy);
axis off; axis equal; axis 'ij';     % fix the axis
title('edge map gradient');

% display the GVF
subplot(224); quiver(px,py);
axis off; axis equal; axis 'ij';     % fix the axis
title('normalized GVF field');

% snake deformation
disp(' Press any key to start GVF snake deformation');
pause;
figure(1); subplot(221); cla;
colormap(gray(64)); image(((1-f)+1)*40); axis('equal', 'off');
%      t = 0:0.05:6.28;
%      x = 45 + 40*cos(t);
%      y = 40 + 35*sin(t);
[x, y] = snakeinit(1);
[x,y] = snakeinterp(x,y,2,0.5);
snakedisp(x,y,'r')
pause(1);

for i=1:25,
    [x,y] = snakedeform(x,y,0.05,0,1,0.5,fx,fy,5);
    [x,y] = snakeinterp(x,y,2,0.5);
    snakedisp(x,y,'r')
    title(['Deformation in progress,  iter = ' num2str(i*5)])
    pause(0.5);
end

disp(' Press any key to display the final result');
pause;
cla;
colormap(gray(64)); image(((1-f)+1)*40); axis('equal', 'off');
snakedisp(x,y,'r')
title(['Final result,  iter = ' num2str(i*5)]);
disp(' ');
disp(' Press any key to run the next example');
pause;


% ==== Example 2: Room like object ====

% Read in the 64x64 room image
[I,map] = rawread('room.pgm');

% Compute its edge map
disp(' Compute edge map ...');
f = 1 - I/255;

% Compute the GVF of the edge map f
disp(' Compute GVF ...');
[px,py] = GVF(f, 0.2, 80);

% display the results
figure(1);
subplot(221); imdisp(I); title('test image');
subplot(222); imdisp(f); title('edge map');

% display the gradient of the edge map
[fx,fy] = gradient(f);
subplot(223); quiver(fx,fy);
axis off; axis equal; axis 'ij';     % fix the axis
title('edge map gradient');

% display the GVF
subplot(224); quiver(px,py);
axis off; axis equal; axis 'ij';     % fix the axis
title('GVF field');

% snake deformation
disp(' Press any key to start GVF snake deformation');
pause;
figure(1); subplot(221); cla;
colormap(gray(64)); image(((1-f)+1)*40); axis('equal', 'off');
t = 0:0.5:6.28;
x = 32 + 3*cos(t);
y = 32 + 3*sin(t);
[x,y] = snakeinterp(x,y,2,0.5);
snakedisp(x,y,'r');
pause(1);

for i=1:15,
    [x,y] = snakedeform(x,y,0.05,0,1,2,px,py,5);
    [x,y] = snakeinterp(x,y,2,0.5);
    snakedisp(x,y,'r')
    title(['Deformation in progress,  iter = ' num2str(i*5)])
    pause(0.5);
end

disp(' Press any key to display the final result');
pause;
figure(1); subplot(221); cla;
colormap(gray(64)); image(((1-f)+1)*40); axis('equal', 'off');
snakedisp(x,y,'r');
title(['Final result,  iter = ' num2str(i*5)]);
