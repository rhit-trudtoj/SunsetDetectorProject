%Author Owen Trudt
%File created for the Sunset detector project of CSSE463
%Go into files and get tempFeatures/labels


paths = [
"Images/images/train/sunset/",
"Images/images/train/nonsunset/",
"Images/images/test/sunset/",
"Images/images/test/nonsunset/",
"Images/images/validate/sunset/",
"Images/images/validate/nonsunset/"
];

num = max(size(paths)); 

tempFeatures = []; 
labels = []; 

for i = 1:num
    
    imgFiles = dir(fullfile(char(paths(i)),'*.jpg'));
    
    for imgIndex = 1:max(size(imgFiles))
        
        img = imread(strcat(char(paths(i)),imgFiles(imgIndex).name));
        
        extract = FeatureExtraction(img);
        
        tempFeatures = [tempFeatures;extract];
        
        labels = [labels; 2 * contains(paths(i),"/sunset") - 1]; %this gives us either a label of 1 or -1 
        
        
    end 
    
end 

features = normalizeFeatures01(tempFeatures);

save('finalFeat.mat', 'tempFeatures', 'labels', 'features');


