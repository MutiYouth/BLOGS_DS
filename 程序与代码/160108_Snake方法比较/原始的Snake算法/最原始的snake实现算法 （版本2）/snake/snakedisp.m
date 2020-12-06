function snakedisp(x,y,style)
% SNAKEDISP  Initialize the snake 
%      snakedisp(x,y,line)
%       
%      style is same as the string for plot

%      Chenyang Xu and Jerry L. Prince, 5/15/95, 6/17/97
%      Copyright (c) 1995-97 by Chenyang Xu and Jerry L. Prince
%      Image Analysis and Communications Lab, Johns Hopkins University

hold on

% convert to column data
x = x(:); y = y(:);

if nargin == 3
   plot([x;x(1,1)],[y;y(1,1)],style);
   hold off
else
   disp('snakedisp.m: The input parameter is not correct!'); 
end
