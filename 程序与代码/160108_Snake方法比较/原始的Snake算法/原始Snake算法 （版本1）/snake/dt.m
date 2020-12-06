function D = dt(B)
% DT apply Eucledian distance transform
%    D = dt(B) compute the Eucledian distance transform of B
%    B must be a binary map. 
%
% NOTE: this is not an efficient way to implement distance transform. 
%    If one is interested in using DT, one may want to implement its
%    own DT. 

%    Chenyang Xu and Jerry L. Prince 6/17/97
%    Copyright (c) 1996-97 by Chenyang Xu and Jerry L. Prince

[i,j] = find(B);

[n,m] = size(B);
for x = 1:n,
    for y = 1:m,
        dx = i-x;
        dy = j-y;
        dmag = sqrt(dx.*dx+dy.*dy);
	D(x,y) = min(dmag);
    end
end
