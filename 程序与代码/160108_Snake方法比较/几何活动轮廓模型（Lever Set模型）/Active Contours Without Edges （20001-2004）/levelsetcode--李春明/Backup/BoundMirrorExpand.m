function B = BoundMirrorExpand(A)

[M,N] = size(A);
yi = 2:M+1;
xi = 2:N+1;
B = zeros(M+2,N+2);
B(yi,xi) = A;
B([1 M+2],[1 N+2]) = B([3 M],[3 N]);  % mirror corners
B([1 M+2],xi) = B([3 M],xi);          % mirror left and right boundary
B(yi,[1 N+2]) = B(yi,[3 N]);          % mirror top and bottom boundary
