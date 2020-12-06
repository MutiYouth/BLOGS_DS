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

   % Read in the 64x64 room image
     [I,map] = rawread('../images/room.pgm');  
     
   % Compute its edge map
     disp(' Compute edge map ...');
     f = 1 - I/255; 

   % Compute the GVF of the edge map f
     disp(' Compute GVF ...');
     [px,py] = GVF(f, 0.2, 80); 
   
   % display the results
     figure(1); 
     subplot(121); imdisp(-f); title('snake potential');
     subplot(122); quiver(px,py); 
     axis('image', 'ij', 'off');   % fix the axis 
     title('traditional force');

   % snake deformation
     disp(' Press any key to start GVF snake deformation');
     pause;
     figure(1); subplot(121); cla;
     colormap(gray(64)); image(((1-f)+1)*40); axis('equal', 'off');
%      t = 0:0.05:6.28;
%      x = 45 + 40*cos(t);
%      y = 40 + 35*sin(t);
     [x, y] = snakeinit(1);
     pause
     [x,y] = snakeinterp(x,y,2,0.5);
     snakedisp(x,y,'r') 
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
     figure(1); subplot(121); cla;
     colormap(gray(64)); image(((1-f)+1)*40); axis('equal', 'off');
     snakedisp(x,y,'r'); 
     title(['Final result,  iter = ' num2str(i*5)]);
