%Author Owen Trudt
%File created for the Sunset detector project of CSSE463
%Feature Extraction

function [feat] = FeatureExtraction(img)
feat = zeros(1,294);
[height, width, ~] = size(img);

subHeight = floor(height/7); 
subWidth = floor(width/7);

for row = 1:7
    for col = 1:7
        
        %we want to divide our img into a 7x7 grid so we need to get a
        %subimg of that grid
        
        x1 = floor((row-1) * subHeight) + 1; 
        y1 = floor((col-1) * subWidth) + 1; 
        
        x2 = floor(row * subHeight); 
        y2 = floor(col * subWidth); 
        
        subimg = img(x1:x2, y1:y2, :); 
        
        %this gives us a subimg that will fill out our 7x7 grid
        
        red = double(subimg(:,:,1));
        green = double(subimg(:,:,2));
        blue = double(subimg(:,:,3));
        % get the rgb bands so we can calculate the lst values
        
        L = red + blue + green;
        S = red - blue;
        T = red-2*green + blue;
        
        feat((row-1)*6 + (col-1)*42 + 1) = mean(mean(L));
        feat((row-1)*6 + (col-1)*42 + 2) = std(L(:));
        feat((row-1)*6 + (col-1)*42 + 3) = mean(mean(S));
        feat((row-1)*6 + (col-1)*42 + 4) = std(S(:));
        feat((row-1)*6 + (col-1)*42 + 5) = mean(mean(T));
        feat((row-1)*6 + (col-1)*42 + 6) = std(T(:));
       
        %put data into feature matrix
        
    end
end