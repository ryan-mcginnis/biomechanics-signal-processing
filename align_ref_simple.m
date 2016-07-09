function [R,Ba] = align_ref_simple(A,B)
%Function to align reference frames of two sets of data via rigid body rotation
%Inputs:
%1. A - reference data set (Nx3) - resolved in reference frame Fa
%2. B - data set to rotate (Nx3) - resolved in reference frame Fb

%Output:
%1. R - Rotation matrix that defines the transformation from Fb to Fa such that
%   a column vector resolved in Fb (xb) is resolved in Fa as per: xa = R * xb
%2. Ba - input data B resolved in Fa

%Define centroid and size of data
centroid_A = mean(A);
centroid_B = mean(B);
N = size(A,1);

%Calculate covariance matrix
H = (A - repmat(centroid_A, N, 1))' * (B - repmat(centroid_B, N, 1));

%Singular value decomposition
[U,~,V] = svd(H);

%Construct rotation
R = V*U';

%Address limiting case
if det(R) < 0
    V(:,3) = -V(:,3);
    R = V*U';
end

%Apply rotation to B
Ba = B * R; %use row-vector form of rotation matrix to reduce computation

%Transform R into more standard definition 
R = R.'; % transpose R to put in column-vector form such that xr = R * x

end
