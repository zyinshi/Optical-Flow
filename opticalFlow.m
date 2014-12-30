function [u, v, hitMap] = opticalFlow(I1,I2,windowSize, tau)
% clear 
% close all

% I1 = imread('flower/00029.png');
% I2 = imread('flower/00030.png');
% tau = 0.01;
% windowSize = 15;

if size(I1,3) == 3
        I1 = rgb2gray(I1);
end
I1 = mat2gray(I1);
if size(I2,3) == 3
        I2 = rgb2gray(I2);
end
I2 = mat2gray(I2);

h = fspecial('gaussian', [3,3], 1);
I1 = imfilter(I1,h);
I2 = imfilter(I2,h);

d = 1/12.*[-1,8,0,-8,1];
Ix = conv2(I1, d,'same');
Iy = conv2(I1,d', 'same');
It = I2-I1;

sz = size(I1);

X2 = conv2(Ix.^2, ones(windowSize),'same');
Y2 = conv2(Iy.^2, ones(windowSize),'same');
XY = conv2(Ix.*Iy, ones(windowSize),'same');
XT = conv2(Ix.*It, ones(windowSize),'same');
YT = conv2(Iy.*It, ones(windowSize),'same');


hitMap = zeros(sz);
u = zeros(sz);
v = zeros(sz);
hsz = floor(windowSize/2);
for i = 1:sz(1)
    for j = 1:sz(2)
        left = j-hsz; right = j+hsz;
        top = i-hsz; bottom = i+hsz;
        if(left<=0), left=1; end
        if(right>sz(2)), right=sz(2); end
        if(top<=0), top = 1; end
        if(bottom>sz(1)), bottom=sz(1); end
        ws = (right-left+1)*(bottom-top+1);
        
        A = [X2(i,j) XY(i,j); XY(i,j) Y2(i,j)]/ws;

        B = (-1).*[XT(i,j); YT(i,j)]/ws;
        r = rank(A);
        lambda = eig(A);
        if (min(lambda)>tau)
            hitMap(i,j) = 1;
            U = A\B;
            u(i,j) = U(1);
            v(i,j) = U(2);
        end
        
    end
end


end
