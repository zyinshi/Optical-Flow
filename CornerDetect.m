function corners = CornerDetect(Image, nCorners, smoothSTD, windowSize)
%     Image = warrior01;
%     nCorners = 20;
%     smoothSTD = 3;
%     windowSize=11;
    
    if size(Image,3) == 3
        Image = rgb2gray(Image);
    end
    Image = im2double(Image);
    
    %% Smoothing and Differentiation 
    ksz =floor(windowSize/2);
    hsz = floor(windowSize/2);    %half size   
    n = -ksz:ksz;
%     tail = ceil(3.5 * sigma);
%     n = -tail:tail;
    sigma = smoothSTD;
    g = gaussian(n',sigma);
    d = d_gaussian(n', sigma); % generate deriviate of Gaussian
    gx = conv2(d, g, Image, 'valid');
    gy = conv2(g, d, Image, 'valid');
    [rows, cols] = size(Image);
    xg = zeros(rows, cols);
    xg(1 + ksz:end-ksz,1+ksz:end-ksz)=gx;
    yg = zeros(rows, cols);
    yg(1 + ksz:end-ksz,1+ksz:end-ksz)=gy;
    
    X2 = conv2(xg.^2, ones(windowSize),'same');
    Y2 = conv2(yg.^2, ones(windowSize),'same');
    XY = conv2(xg.*yg, ones(windowSize),'same');
    
    %% find corners
    for y=1:rows
        for x=1:cols
            
            C = [X2(y,x),XY(y,x);XY(y,x),Y2(y,x)];
            lambda = svd(C);
            e(y,x) = min(lambda);
          
        end
    end
    %% suppression
    corner = zeros(size(e));
    for y=hsz+1:rows-hsz
        for x=hsz+1:cols-hsz
            window = e(y-hsz:y+hsz, x-hsz:x+hsz);
            [val, ind]=max(window(:));
            [offy, offx]= ind2sub(size(window),ind);
            if(y==y-hsz+offy-1 && x==x-hsz+offx-1)
                corner(y,x)=e(y,x);
            end
        end
    end
    
    %% extract
    [res, index]=sort(corner(:),'descend');
    [py, px]=ind2sub(size(corner),index);
    close all;
    figure;
    imagesc(Image);colormap gray;
    hold on
    set(0,'DefaultLineMarkerSize', 10);
    set(0, 'DefaultLineLineWidth', 2);
    set(gcf, 'Color', [1 1 1]);
    for i=1:nCorners
        plot(px(i), py(i),'ro');
    end
    corners = [ py(1:nCorners), px(1:nCorners),res(1:nCorners)];
    
end