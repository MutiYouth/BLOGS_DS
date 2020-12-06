function [xi,yi] = snakeinterp1(x,y,RES)
% SNAKEINTERP1  Interpolate the snake to have equal distance RES
%     [xi,yi] = snakeinterp(x,y,RES)
%
%     RES: resolution desired

%     update on snakeinterp after finding a bug

%      Chenyang Xu and Jerry L. Prince, 3/8/96, 6/17/97
%      Copyright (c) 1996-97 by Chenyang Xu and Jerry L. Prince
%      Image Analysis and Communications Lab, Johns Hopkins University

% convert to column vector
x = x(:); y = y(:);

N = length(x);  

% make it a circular list since we are dealing with closed contour
x = [x;x(1)];
y = [y;y(1)];

dx = x([2:N+1])- x(1:N);
dy = y([2:N+1])- y(1:N);
d = sqrt(dx.*dx+dy.*dy);  % compute the distance from previous node for point 2:N+1

d = [0;d];   % point 1 to point 1 is 0 

% now compute the arc length of all the points to point 1
% we use matrix multiply to achieve summing 
M = length(d);
d = (d'*uppertri(M,M))';

% now ready to reparametrize the closed curve in terms of arc length
maxd = d(M);

if (maxd/RES<3)
   error('RES too big compare to the length of original curve');
end

di = 0:RES:maxd;

xi = interp1(d,x,di);
yi = interp1(d,y,di);

N = length(xi);

if (maxd - di(length(di)) <RES/2)  % deal with end boundary condition
   xi = xi(1:N-1);
   yi = yi(1:N-1);
end
