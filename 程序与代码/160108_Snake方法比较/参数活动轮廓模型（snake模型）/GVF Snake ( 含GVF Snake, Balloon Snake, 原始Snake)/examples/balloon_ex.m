% EXAMPLE     an example of balloon model on the room object       
%

%   Chenyang Xu and Jerry Prince 6/17/97
%   Copyright (c) 1996-97 by Chenyang Xu and Jerry Prince

   cd ..;   s = cd;   s = [s, '/snake']; path(s, path); cd examples;
   
   help balloon_ex;

   % Read in the 64x64 room image
     [I,map] = rawread('../images/room.pgm');  
     
   % Compute its edge map
     disp(' Compute edge map ...');
     f = 1 - I/255; 
     f0 = gaussianBlur(f,1);
     % note: snake potential is the negative of edge map
     disp(' Comute the traditional external force ...');
     [px,py] = gradient(f0);

   % display the results
     figure(1); 
     subplot(121); imdisp(-f); title('snake potential');
     subplot(122); quiver(px,py); 
     axis('square', 'equal', 'off', 'ij');     % fix the axis 
     title('traditional force');
       
   % balloon deformation
     disp(' ');
     disp(' Press any key to start the deformation');
     pause;
     figure(1); subplot(121); cla; 
     colormap(gray(64)); image(((1-f)+1)*40); axis('square', 'equal', 'off');
     t = 0:0.5:6.28;
     x = 32 + 3*cos(t);
     y = 32 + 3*sin(t);
     [x,y] = snakeinterp(x,y,2,0.5);
     snakedisp(x,y,'r') 
     pause(1);

     for i=1:15,
       [x,y] = snakedeform2(x,y,0.05,0,1, 2, 0.15,px,py,5);
       [x,y] = snakeinterp(x,y,2,0.5);
       snakedisp(x,y,'r') 
       title(['Deformation in progress,  iter = ' num2str(i*5)])
       pause(0.5);
     end

     disp(' ');
     disp(' Press any key to display the final result');
     pause;
     figure(1); subplot(121); cla; 
     colormap(gray(64)); image(((1-f)+1)*40); axis('square', 'equal', 'off');
     snakedisp(x,y,'r'); 
     title(['Final result,  iter = ' num2str(i*5)]);

     




