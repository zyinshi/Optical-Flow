clear,
tau = 0.2;
% I1 = imread('synth/synth_000.png');
% I2 = imread('synth/synth_001.png');
I1 = imread('corridor/bt.000.png');
I2 = imread('corridor/bt.001.png');
% I1 = imread('sphere/sphere.0.png');
% I2 = imread('sphere/sphere.1.png');
% I1 = imread('flower/00029.png');
% I2 = imread('flower/00030.png');
windowSize = [15,30,100];

%% optical flow
res=cell(3,2);
for w=1:3
    wsize = windowSize(w);
    [u, v, hitMap] = opticalFlow(I1,I2,wsize, tau);
    saveas(gca, ['map',w,'.png']);

    [x, y] = meshgrid(1:10:size(I1,1), size(I1,1):-10:1);
    
    qu = u(1:10:size(I1,1), 1:10:size(I1,2));
    qv = v(1:10:size(I1,1), 1:10:size(I1,2));
    
    subplot(2,3,w), quiver(x,y, qu, -qv,'linewidth', 1),axis([1,size(I1,1),1,size(I1,2)]), title(sprintf('windowSize=%d',wsize));
    subplot(2,3,w+3), imagesc(hitMap),colormap(gray), title(sprintf('windowSize=%d',wsize));
    
end

%% sparse corners
corners = CornerDetect(I1, 50, 1, 7);
saveas(gca, ['corners.png']);
[u, v, hitMap] = opticalFlow(I1,I2,100, tau);
for i=1:50
    c(i,1)=u(corners(i,1),corners(i,2));
    c(i,2)=v(corners(i,1),corners(i,2));
end
figure;
imagesc(I1);colormap gray
hold on;
plot(corners(:,2), corners(:,1), 'ro', 'MarkerSize', 7, 'linewidth',2), title('corners and optical flow');

hold on;
quiver(corners(:,2),corners(:,1),c(:,1),c(:,2),1,'linewidth',2);