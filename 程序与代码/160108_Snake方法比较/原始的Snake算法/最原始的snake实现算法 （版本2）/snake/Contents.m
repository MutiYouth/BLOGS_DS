% GVF snake (active contour) toolbox
% Version 1.0 17-June-1997
% Copyright (c) 1996-1997 by Chenyang Xu and Jerry L. Prince 
%
%  Image input/output
%    rawread       - Read a Portable Bitmap file, or a raw file
%    rawwrite      - Write a Portable Bitmap file, or a raw file
% 
%  Image Display
%    imdisp        - Display an image
% 
%  Active Contour
%    snakeinit     - Initialize the snake manually
%    snakedeform   - Deform snake in the given external force field
%    snakedeform2  - Deform snake in the given external force field with
%                    pressure force
%    snakedisp     - Display a snake
%    snakeinterp   - Interpolate the snake adaptively
%    snakeinterp1  - Interpolate the snake at a fixed resolution
%                    (better implemented than snakeinterp)
% 
%  Gradient Vector Flow
%    GVF           - Compute the gradient vector flow field
% 
%  Other
%    dt            - Simple distance transform
%    gaussianBlur  - Blurring an image using gaussian kernel   
%    gaussianMask  - Generate a discrete gaussian mask

