%Author Owen Trudt
%File created for the Sunset detector project of CSSE463
%Train the svm

load('finalFeat.mat');

train = features(1:1599,:); 
trainLabel = labels(1:1599,:);

test = features(1600:2599,:); 
testLabel = labels(1600:2599,:); 

valid = features(2600:3198,:);
validLabels = labels(2600:3198,:); 

%found with code commented below
kernelWidth = 16; 
box = 16; 

net = fitcsvm(train, trainLabel, 'KernelFunction', 'rbf', 'KernelScale', kernelWidth, 'BoxConstraint', box, 'Standardize', true);

% [label, distance] = predict(net, valid); 
% 
%  confusion = confusionmat(validLabels, label); 
%         
%  truePositives = confusion(1, 1);
%  falsePositives = confusion(2, 1);
%  falseNegatives = confusion(1, 2);
%  trueNegatives = confusion(2, 2);
%        
%  accuracy = (truePositives + trueNegatives) / (truePositives + falsePositives + falseNegatives + trueNegatives);
%  
%  TPR = truePositives / (truePositives + falseNegatives);
% 
%  FPR = falsePositives / (falsePositives + trueNegatives);
% 
%  [supportVectors, ~] = size(net.SupportVectors); 
%  
% disp("Accuracy: " + accuracy);
% disp("True Positive rate: " + TPR);
% disp("False Positive rate: " + FPR);
% disp("Number of support vectors: " + supportVectors);

%time to plot our ROC curve

roc = []; %holds the thresh, tpr, fpr, accuracy

for thresh=linspace(-2,2,101)
   
    [label, score] = predict(net, test);
    trueP =  sum((score(:,2)>thresh)&(testLabel==1)); 
    falseP = sum((score(:,2)>thresh)&(testLabel==-1)); 
    
    falseN = sum((score(:,2)<thresh)&(testLabel==1)); 
    trueN = sum((score(:,2)<thresh)&(testLabel==-1));
    
    fpr = falseP / (falseP + trueN); 
    tpr = trueP / (trueP + falseN); 
    
    accuracy = (trueP + trueN) / (trueP + falseP + falseN + trueN);
    
    roc = [roc; thresh, tpr, fpr, accuracy];
    
    
end

%plot the roc 

figure(1); 
hold on; 
threshold = roc(:,1);
truePosRate = roc(:,2);
falsePosRate = roc(:,3); 

plot(falsePosRate, truePosRate, 'b-', 'LineWidth', 2);
% Overlaid with circles at the data points
plot(falsePosRate, truePosRate, 'bo', 'MarkerSize', 3, 'LineWidth', 2);

title(sprintf('Kernel Width=%.1f, Box Constraint=%.1f',kernelWidth, box), 'fontSize', 18); % Really. Change this title.
xlabel('False Positive Rate', 'fontWeight', 'bold');
ylabel('True Positive Rate', 'fontWeight', 'bold');
% TPR and FPR range from 0 to 1. You can change these if you want to zoom in on part of the graph.
axis([0 1 0 1]);

distance = falsePosRate.^2 + (1-truePosRate).^2; 
optimalThresh = threshold(find(distance == min(distance)));

disp("The optimal threshold is: " + num2str(optimalThresh)); 

save('threshold and net.mat', 'net', 'optimalThresh', 'falsePosRate', 'truePosRate'); 

% %optimize paramters (width and box)
% 
data = []; 
% %collected data will be width, box and the accuracy, tpr, fpr, and num
% %support vectors
% 
% for i = 1:10
%     
%     kernelWidth = power(2,i); 
%     
%     for j = 1:10
%         
%         box = power(2,j); 
%         
%         net = fitcsvm(train, trainLabel, 'KernelFunction', 'rbf', 'KernelScale', kernelWidth, 'BoxConstraint', box, 'Standardize', true);
%         
%         [label, distance] = predict(net, valid); 
%         
%         %copied from my toyproblem code 
%         confusion = confusionmat(validLabels, label); 
%         
%         truePositives = confusion(1, 1);
%         falsePositives = confusion(2, 1);
%         falseNegatives = confusion(1, 2);
%         trueNegatives = confusion(2, 2);
%         
%         accuracy = (truePositives + trueNegatives) / (truePositives + falsePositives + falseNegatives + trueNegatives);
% 
%         TPR = truePositives / (truePositives + falseNegatives);
% 
%         FPR = falsePositives / (falsePositives + trueNegatives);
% 
%         supportVectors = net.SupportVectors; 
%         
%         data = [data; kernelWidth, box, TPR, FPR, accuracy, size(net.SupportVectorLabels)];
% 
%     end
% end
% disp(data);
% save('svmOptimal.mat', 'data');
