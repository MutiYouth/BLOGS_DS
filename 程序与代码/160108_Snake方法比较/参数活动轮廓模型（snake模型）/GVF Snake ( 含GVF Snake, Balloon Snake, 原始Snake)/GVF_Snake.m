function [x,y] = GVF_Snake(I)
% This procedure implements gradient vector field based snake algorithm

close all;



% Get image dimensions
[ImRow ImCol ColorNum] = size(I);

% Covert color image to gray image
if( ColorNum > 1 )
    I = rgb2gray(I);
end
I=double(I);

% Compute its edge map
disp(' Compute edge map ...');
[X Y] = meshgrid(-2:1:2, -2:1:2);
Z = exp(-(X.^2 + Y.^2)/2);
G = Z/sum(sum(Z));

E = conv2(double(I), G, 'valid');
E = abs(del2(E));
Emin = min(min(E));
Emax = max(max(E));
E = (E - Emin)/(Emax - Emin + 1e-5) * 255;
figure, imagesc(I);

%f = edge(I, 'canny', [0, 0.05]);
f=logical(I);
% Compute the GVF of the edge map f
disp(' Compute GVF ...');
[u,v] = GVF(f, 0.2, 80); 
disp(' Nomalizing the GVF external force ...');
mag = sqrt(u.*u+v.*v);
px = u./(mag+1e-10); py = v./(mag+1e-10); 

% Display the results
figure; 
colormap(gray);
subplot(221); imagesc(E); title('test image');
subplot(222); imagesc(f); title('edge map');

% Display the gradient of the edge map
[fx,fy] = gradient(f); 
subplot(223); quiver(fx,fy); 
axis off; axis equal; axis 'ij';     % fix the axis 
title('edge map gradient');

% Display the GVF 
subplot(224); quiver(px,py);
axis off; axis equal; axis 'ij';     % fix the axis 
title('normalized GVF field');

% Snake deformation
subplot(221);
image(((1-f)+1)*40); 
axis('square', 'off');

% x = [3:1:(Width - 2), ones(1, Height - 4) * (Width - 1), (Width - 2):-1:3, ones(1, Height - 4) * 2];
% y = [2 * ones(1, Width - 4), 3:1:(Height - 2), ones(1, Width - 4) * (Height - 2), (Height - 2):-1:3];
[x, y] = snakeinit(1);

[x,y] = snakeinterp(x,y,3,1); % this is for student version
% for professional version, use 
%   [x,y] = snakeinterp(x,y,2,0.5);

snakedisp(x,y,'r') 
pause(1);

for i=1:8,
[x,y] = snakedeform(x,y,0.05,0,1,0.6,px,py,5);
[x,y] = snakeinterp(x,y,2,0.5);
    
snakedisp(x,y,'r') 
title(['Deformation in progress,  iter = ' num2str(i*5)])
pause(0.5);
end

cla;
colormap(gray(64)); image(((1-f)+1)*40); axis('square', 'off');
snakedisp(x,y,'r') 
title(['Final result,  iter = ' num2str(i*5)]);