function acc=testAll(models,testImgNames, testLabels,consts,allClasses)
%% Compute feature vector for every image given the class structure
featureVectors = [];
for imgNo = 1:size(testLabels, 1);
    I = loadImg(trainImgNames{imgNo}, consts.IMG_DIR);
    % Compute feature vector
    featureVect=ExtractFeatures(I);
    featureVectors = [featureVectors featureVect];
end
for i = 1:length(allClasses)
svmLabel = (testLabels == allClasses(i)) * 2 - 1; % Convert label to +-1
[predictedLabel, accuracy, decisionValues] = svmpredict(svmLabel, featureVectors', models{i});
probability=[probability decisionValues];
end
[~,indexOfBestClass]=max(probability');
acc=sum(allClasses(indexOfBestClass)==testLabels)/length(testLabels);