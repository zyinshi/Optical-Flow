function [FU,FV] = iterOpticalflow(I1,I2,initu,initv,windowSize,tau,MAXI)

if size(I1,3) == 3
        I1 = rgb2gray(I1);
end
I1 = mat2gray(I1);
if size(I2,3) == 3
        I2 = rgb2gray(I2);
end
I2 = mat2gray(I2);

% h = fspecial('gaussian', [3,3], 1);
% I1 = imfilter(I1,h);
% I2 = imfilter(I2,h);

d = 1/12.*[-1,8,0,-8,1];
sz = size(I1);
Ix = conv2(I1, d,'same');
Iy = conv2(I1,d', 'same');

X2 = conv2(Ix.^2, ones(windowSize),'same');
Y2 = conv2(Iy.^2, ones(windowSize),'same');
XY = conv2(Ix.*Iy, ones(windowSize),'same');


%% iterative
FU = zeros(sz);
FV = zeros(sz);
hsz = floor(windowSize/2);
for i = 1:sz(1)
    for j =1:sz(2)
        left = j-hsz; right = j+hsz;
        top = i-hsz; bottom = i+hsz;
        if(left<=0), left=1; end
        if(right>sz(2)), right=sz(2); end
        if(top<=0), top = 1; end
        if(bottom>sz(1)), bottom=sz(1); end
        win1 = I1(top:bottom,left:right);
        ix = Ix(top:bottom,left:right);
        iy = Iy(top:bottom,left:right);
        A = [X2(i,j) XY(i,j); XY(i,j) Y2(i,j)];
%         lambda = eig(A);
        r = rank(A);
        if(r~=2) 
            Ainv = zeros(2);
        else 
            Ainv = inv(A);
        end
        u=initu(i,j);
        v=initv(i,j);
        for iter = 1:MAXI
            [x,y] = meshgrid(1:size(I1,2), 1:size(I1,1));
            xp = x+u;
            yp = y+v;

            win2 = interp2(x,y,I2,xp(top:bottom,left:right),yp(top:bottom,left:right));
            
            it = win2-win1;
            ixt = it.*ix;
            iyt = it.*iy;
            B = -1.*[sum(ixt(:)); sum(iyt(:))];
            U = Ainv*B;
            U(isnan(U)) = 0 ;
            u = u+U(1); v = v+U(2);
            if(abs(U(1))<tau && abs(U(2))<tau) break;end
        end
        FU(i,j)=u; FV(i,j)=v;
    end
    
end

[x, y] = meshgrid(1:5:size(I1,2), size(I1,1):-5:1);
qu = FU(1:5:size(I1,1), 1:5:size(I1,2));
qv = FV(1:5:size(I1,1), 1:5:size(I1,2));
figure,title('dense')
quiver(x,y, qu, -qv,'linewidth', 1);
end     