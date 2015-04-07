function prediction = classifyImg(I, model, consts)

%% Calculate structure
structure = computeStructure(I, consts.PRUNING_DEPTH_MAX,...
    consts.WNAME, consts.ENTROPY, consts.ENT_PARAM, consts.DEBUG);

selectedClasses = pickLikelyClasses(structure, model, consts);

for class = selectedClasses
%% Calculate feature vector

%% Apply to SVM

    
    featureVector=(featureVector-repmat(classmodel.normmin,[size(featureVector,1) 1]))./(repmat(classmodel.normmax-classmodel.normmin,[size(featureVector,1) 1]));
    [predicted_label, accuracy, decision_values] = svmpredict(((Y==class)*2)-1, featureVector, model); % test the training data
end


end