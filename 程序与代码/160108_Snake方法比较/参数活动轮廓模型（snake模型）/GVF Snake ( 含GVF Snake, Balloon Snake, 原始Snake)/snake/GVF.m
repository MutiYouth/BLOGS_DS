function [u,v] = GVF(f, mu, ITER)
%GVF Compute gradient vector flow.
%   [u,v] = GVF(f, mu, ITER) computes the
%   GVF of an edge map f.  mu is the GVF regularization coefficient
%   and ITER is the number of iterations that will be computed.  

%   Chenyang Xu and Jerry L. Prince 6/17/97
%   Copyright (c) 1996-97 by Chenyang Xu and Jerry L. Prince
%   Image Analysis and Communications Lab, Johns Hopkins University

[fx,fy] = gradient(f); % Calculate the gradient of the edge map
u = fx; v = fy; % Initialize GVF to the gradient
SqrMagf = fx.*fx + fy.*fy; % Squared magnitude of the gradient field

% Iteratively solve for the GVF u,v
for i=1:ITER,
  u = u + mu*4*del2(u) - SqrMagf.*(u-fx);
  v = v + mu*4*del2(v) - SqrMagf.*(v-fy);
  fprintf(1, '%3d', i);
  if (rem(i,20) == 0)
     fprintf(1, '\n');
  end 
end
fprintf(1, '\n');
