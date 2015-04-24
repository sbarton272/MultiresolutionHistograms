function C = testAll(models, testImgNames, testLabels, consts, allClasses)

%% Compute feature vector for every image given the class structure
featureVectors = [];
for imgNo = 1:size(testLabels, 1);
    I = loadImg(testImgNames{imgNo}, consts.IMG_DIR);
    % Compute feature vector
    featureVect=ExtractFeatures(I);
    featureVectors = [featureVectors featureVect];
end
probability=[];
for i = 1:length(allClasses)
    svmLabel = (testLabels == allClasses(i)) * 2 - 1; % Convert label to +-1
    [predictedLabel, accuracy, decisionValues] = svmpredict(svmLabel, featureVectors', models{i});
    keyboard;
    probability=[probability decisionValues];
end

[~,indexOfBestClass] = max(probability');
C = getCounts(testLabels, allClasses(indexOfBestClass), allClasses);

end

function C = getCounts(targetLabel, guess, allClasses)
C = zeros(length(allClasses));

for k = 1:length(targetLabel)
    % C(i,j) class i count, predicted j
    i = find(allClasses == targetLabel(k));
    j = find(allClasses == guess(k));
    C(i,j) = C(i,j) + 1;
end

end
