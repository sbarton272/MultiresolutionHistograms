function C = testMultiHist(model, testImgNames, testLabels,...
    labelMapping, consts)

for i=1:size(testImgNames,1)
%% Extract structure

%% Naive Bayes with structure

for class = selectedClasses
%% Calculate feature vector

%% Apply to SVM

    
    featureVector=(featureVector-repmat(classmodel.normmin,[size(featureVector,1) 1]))./(repmat(classmodel.normmax-classmodel.normmin,[size(featureVector,1) 1]));
    [predicted_label, accuracy, decision_values] = svmpredict(((Y==class)*2)-1, featureVector, model); % test the training data
end

end

%% Pick best match

end
