function phi = evolution_cv(IMG, phi0, mu, nu, lambda_1, lambda_2, delta_t, epsilon, numIter)
%   evolution_withoutedge(I, phi0, mu, nu, lambda_1, lambda_2, delta_t, delta_h, epsilon, numIter);
%   input:
%       I:          input image
%       phi0:       level set function to be updated
%       mu:         weight for length term
%       nu:         weight for area term, default value 0
%       lambda_1:   weight for c1 fitting term
%       lambda_2:   weight for c2 fitting term
%       delta_t:    time step
%       epsilon:    parameter for computing smooth Heaviside and dirac function
%       numIter:    number of iterations
%   output:
%       phi: updated level set function


IMG=BoundMirrorExpand(IMG);
phi=BoundMirrorExpand(phi0);

for k=1:numIter
    phi=BoundMirrorEnsure(phi);
    delta_h=Delta(phi,epsilon);
    Curv = curvature(phi);
    [C1,C2]=binaryfit(phi,IMG,epsilon);
    % updating the phi function
    phi=phi+delta_t*delta_h.*(mu*Curv-nu-lambda_1*(IMG-C1).^2+lambda_2*(IMG-C2).^2);
end
phi=BoundMirrorShrink(phi);





% FUNCTIONS
% --------------------------------------------------------------------------------
function B = BoundMirrorExpand(A)

[M,N] = size(A);
yi = 2:M+1;
xi = 2:N+1;
B = zeros(M+2,N+2);
B(yi,xi) = A;
B([1 M+2],[1 N+2]) = B([3 M],[3 N]);  % mirror corners
B([1 M+2],xi) = B([3 M],xi);          % mirror left and right boundary
B(yi,[1 N+2]) = B(yi,[3 N]);          % mirror top and bottom boundary

function B = BoundMirrorEnsure(A)

[m,n] = size(A);
if (m<3 || n<3) 
    error('either the number of rows or columns is smaller than 3');
end
yi = 2:m-1;
xi = 2:n-1;
B = A;
B([1 m],[1 n]) = B([3 m-2],[3 n-2]);  % mirror corners
B([1 m],xi) = B([3 m-2],xi);          % mirror left and right boundary
B(yi,[1 n]) = B(yi,[3 n-2]);          % mirror top and bottom boundary

function Delta_h = Delta(phi, epsilon)
% Delta(phi, epsilon) compute the smooth Dirac function
Delta_h=(epsilon/pi)./(epsilon^2+ phi.^2);

function B = BoundMirrorShrink(A)
[m,n] = size(A);
yi = 2:m-1;
xi = 2:n-1;
B = A(yi,xi);

function [C1,C2]= binaryfit(phi,IMG,epsilon)  
%   input: 
%       IMG: input image
%       phi: level set function
%       epsilon: parameter for computing smooth Heaviside and dirac function
%   output: 
%       C1: a constant to fit the image U in the region phi>0
%       C2: a constant to fit the image U in the region phi<0

% compute the Heaveside function values 
H = Heaviside(phi,epsilon); 

a= H.*IMG;
numer_1=sum(a(:)); 
denom_1=sum(H(:));
C1 = numer_1/denom_1;

b=(1-H).*IMG;
numer_2=sum(b(:));
c=1-H;
denom_2=sum(c(:));
C2 = numer_2/denom_2;

function H = Heaviside(phi,epsilon) 
%   Heaviside(phi,epsilon)  compute the smooth Heaviside function
H = 0.5*(1+ (2/pi)*atan(phi./epsilon));

function K=curvature(Phi)
%   K=curvature(f);
%   K=div(Df/|Df|)
%    =(fxx*fy^2+fyy*fx^2-2*fx*fy*fxy)/(fx^2+fy^2)^(3/2) 

[f_fx,f_fy]=forward_gradient(Phi);
[f_bx,f_by]=backward_gradient(Phi);

mag1=sqrt(f_fx.^2+f_fy.^2+1e-10);
n1x=f_fx./mag1;
n1y=f_fy./mag1;

mag2=sqrt(f_bx.^2+f_fy.^2+1e-10);
n2x=f_bx./mag2;
n2y=f_fy./mag2;

mag3=sqrt(f_fx.^2+f_by.^2+1e-10);
n3x=f_fx./mag3;
n3y=f_by./mag3;

mag4=sqrt(f_bx.^2+f_by.^2+1e-10);
n4x=f_bx./mag4;
n4y=f_by./mag4;

nx=n1x+n2x+n3x+n4x;
ny=n1y+n2y+n3y+n4y;

magn=sqrt(nx.^2+ny.^2);
nx=nx./(magn+1e-10);
ny=ny./(magn+1e-10);

[nxx,nxy]=gradient(nx); %#ok<*NASGU>
[nyx,nyy]=gradient(ny); %#ok<ASGLU>

K=nxx+nyy;

