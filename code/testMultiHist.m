function C = testMultiHist(model, testImgNames, testLabels,...
    labelMapping, consts)
for i=1:length(testImgNames)
    I = imread(testImgNames{i});
    
%% Extract structure
structure = computeStructure(I, consts.PRUNING_DEPTH_MAX,...
            consts.WNAME, consts.ENTROPY, consts.ENT_PARAM, true);

%% Naive Bayes with structure
probabilityofstructure=zeros(1,length(model));
for classind=1:length(model)
   probabilityofstructure(classind)=prod(structure-(model.classes{classind}.structureProb==0));
end
selectedClasses=find(probabilityofstructure>=consts.NB_THRESH);

probabilityList=[];
for class = selectedClasses
%% Calculate feature vector
featureVector = computeFeatureVect(I, model.classes{class}.structure, ...
            consts.PRUNING_DEPTH_MAX, consts.WNAME, consts.ENTROPY);
%% Apply to SVM

    featureVector=(featureVector-repmat(classmodel.normmin,[size(featureVector,1) 1]))./(repmat(classmodel.normmax-classmodel.normmin,[size(featureVector,1) 1]));
    [predicted_label, accuracy, decision_values] = svmpredict(((Y==class)*2)-1, featureVector, model); % test the training data
    probabilityList=[probabilityList decision_values];
    
end
%% Pick best match
[~,indexInSelClasses]=max(probabilityList);
BestMatch=selectedClasses(indexInSelClasses);
C=BestMatch;
end
end
