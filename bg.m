function [background] = backgroundSubtract(framesequence, tau)

% allFiles = dir(fullfile( 'truck','*.png' ));
% allFiles = dir(fullfile( 'truck','*.png' ));
% tau = 0.0001;
frame = cell(size(framesequence));

num = size(allFiles,1);
for n=1:num
    frame{n} = im2double(imread(fullfile('truck',allFiles(n,1).name)));
    
end
% bg = cell(num);
temp = zeros(size(frame{1}));
for i = 2:num
    mask = (frame{i}-frame{i-1})<tau;
   	frame{i}(mask) = 0;
    red = zeros(size(temp));
    red(mask)=temp(mask);
    temp = (temp.*(i-2)+frame{i}+red)./(i-1);
end
imshow(temp);
imwrite(temp, 'back_t.png');

end
     
