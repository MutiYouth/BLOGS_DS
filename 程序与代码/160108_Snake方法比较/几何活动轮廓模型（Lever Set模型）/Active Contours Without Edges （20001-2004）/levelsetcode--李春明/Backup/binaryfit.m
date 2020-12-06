function [C1,C2]= binaryfit(phi,U,epsilon) 
%   [C1,C2]= binaryfit(phi,U,epsilon) computes c1 c2 for optimal binary fitting 
%   input: 
%       U: input image
%       phi: level set function
%       epsilon: parameter for computing smooth Heaviside and dirac function
%   output: 
%       C1: a constant to fit the image U in the region phi>0
%       C2: a constant to fit the image U in the region phi<0

H = Heaviside(phi,epsilon); %compute the Heaveside function values 

a= H.*U;
numer_1=sum(a(:)); 
denom_1=sum(H(:));
C1 = numer_1/denom_1;

b=(1-H).*U;
numer_2=sum(b(:));
c=1-H;
denom_2=sum(c(:));
C2 = numer_2/denom_2;

function H = Heaviside(phi,epsilon) 
%   Heaviside(phi,epsilon)  compute the smooth Heaviside function
H = 0.5*(1+ (2/pi)*atan(phi./epsilon));

