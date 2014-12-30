clear 
close all

I1 = imread('flower/00029.png');
I2 = imread('flower/00030.png');
%% initial & build pyramid
MAXI=10;
tau=0.01;
windowSize = 15;
% d = 1/12.*[-1,8,0,-8,1];

if size(I1,3) == 3
        I1 = rgb2gray(I1);
end
I1 = mat2gray(I1);
if size(I2,3) == 3
        I2 = rgb2gray(I2);
end
I2 = mat2gray(I2);


i1 = cell(3,1);
i1{3} = I1;
i1{2} = impyramid(I1, 'reduce');
i1{1} = impyramid(i1{2}, 'reduce');


i2 = cell(3,1);
i2{3} = I2;
i2{2} = impyramid(I2, 'reduce');
i2{1} = impyramid(i2{2}, 'reduce');


%% iteration optical flow
% initial 
initu=zeros(size(i1{1})); initv=zeros(size(i1{1}));
[u0, v0] = iterOpticalflow(i1{1},i2{1},initu, initv, windowSize,tau, MAXI);

% iterative
tempu = u0; tempv = v0;
for l = 2:3
    upu = imresize(tempu, size(i1{l}));
    upv = imresize(tempv, size(i1{l}));
    upu = 2.*upu;
    upv = 2.*upv;
    [tempu, tempv]=iterOpticalflow(i1{l},i2{l},upu, upv, windowSize,tau, MAXI);
end
    
  
resu = tempu;
resv = tempv;

[x, y] = meshgrid(1:5:size(I1,2), size(I1,1):-5:1);
qu = resu(1:5:size(I1,1), 1:5:size(I1,2));
qv = resv(1:5:size(I1,1), 1:5:size(I1,2));
figure,title('coarse to fine')
quiver(x,y, qu, -qv,'linewidth', 1);

%% segmentation
map = zeros(size(resu));
for i=1:size(resu,1)
    for j=1:size(resu,2)
        map(i,j) =sqrt((resu(i,j)).^2 + (resv(i,j)).^2);
        
    end
end

map(map>5)=0
figure, imagesc(map),title('pyramid');
  
    
    
    
    
    
    
