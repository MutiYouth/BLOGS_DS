function [u,v] = GGVF(f, mu, ITER)
% [u,v] = GGVF(f, mu, ITER)
%
% Generalized Gradient Vector Flow
%
%   Chenyang Xu and Jerry L. Prince 6/17/97
%   Copyright (c) 1996-97 by Chenyang Xu and Jerry L. Prince
%   Image Analysis and Communications Lab, Johns Hopkins University
% 

% del2(u) is not the approximation of laplace operator but
% 4*del2(u) is the approximation of laplace(u)!!!
%
% 1/4*4*del2(U) is stable i.e. del2(U) is stable
%
% dt = 1/4 to make the scheme stable 

[fx,fy] = gradient(f); % Calculate the gradient of the edge map
u = fx; v = fy; % Initialize GVF to the gradient
SqrMagf = fx.*fx + fy.*fy; % Squared magnitude of the gradient field

K2 = mu*mu;

g = exp(-SqrMagf/K2);
h = 1-g;

b = h;
c1 = b.*fx;
c2 = b.*fy;
% iterate solve the u,v
for i=1:ITER,
  u = (1-b/4).*u + g.*del2(u) + c1/4;
  v = (1-b/4).*v + g.*del2(v) + c2/4;

  fprintf(1,' %d ',i);
end

disp(' ');


