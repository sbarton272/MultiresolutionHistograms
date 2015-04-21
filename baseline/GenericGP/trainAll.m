function models=trainAll(trainImgNames, trainLabels,consts,allClasses)
%% Compute feature vector for every image given the class structure
featureVectors = [];
models={};
for imgNo = 1:size(trainLabels, 1);
    I = loadImg(trainImgNames{imgNo}, consts.IMG_DIR);
    % Compute feature vector
    featureVect=ExtractFeatures(I);
    featureVectors = [featureVectors featureVect];
end

opt = sprintf('-t %d -c %f -b %d -q %d', 2, consts.SVM_C, 1, 0);

for i = 1:length(allClasses)


svmLabel = (trainLabels == allClasses(i)) * 2 - 1; % Convert label to +-1
models{i} = svmtrain(svmLabel, featureVectors', opt);
end