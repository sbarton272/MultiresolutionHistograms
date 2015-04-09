function C = testMultiHist(model, testImgNames, testLabels,...
    labelMapping, consts)

allClasses = unique(testLabels);
numClasses = length(allClasses);
C = zeros(numClasses);

for i=1:length(testImgNames)
    I = loadImg(testImgNames{i}, consts.IMG_DIR);
    
%% Extract structure
structure = computeStructure(I, consts.PRUNING_DEPTH_MAX,...
            consts.WNAME, consts.ENTROPY, consts.ENT_PARAM, true);

%% Naive Bayes with structure
probabilityofstructure=zeros(1,numClasses);
for classind=1:numClasses
    structureProb = model.classes{classind}.structureProb;
    prob = structureProb .* (structure == 1) + (1-structureProb) .* (structure == 0);
    probabilityofstructure(classind)= sum(log(prob));
end
selectedClasses = find(probabilityofstructure>=log(consts.USE_CLASS_SVM_THRESH));

% If nothing above the threshold, try everything
if isempty(selectedClasses)
    selectedClasses = 1:numClasses;
end

probabilityList=[];
for class = selectedClasses
%% Calculate feature vector
    featureVector = computeFeatureVect(I, model.classes{class}.structure, ...
            consts.PRUNING_DEPTH_MAX, consts.WNAME, consts.ENTROPY, consts.NUM_BINS);
%% Apply to SVM
    classModel = model.classes{class};
    featureVector=(featureVector-repmat(classModel.normMin,[size(featureVector,1) 1]))./(repmat(classModel.normMax-classModel.normMin,[size(featureVector,1) 1]));
    [predicted_label, accuracy, decision_values] = svmpredict(((Y==class)*2)-1, featureVector, classModel.svm); % test the training data
    probabilityList=[probabilityList decision_values];
    
end

%% Pick best match
[~,indexInSelClasses]=max(probabilityList);
BestMatch=selectedClasses(indexInSelClasses);
C = updateCounts(C, testLabels(i), BestMatch, allClasses);
end

end

function C = updateCounts(C, targetLabel, guess, allClasses)
% C(i,j) class i count, predicted j
i = find(allClasses == targetLabel);
j = find(allClasses == guess);
C(i,j) = C(i,j) + 1;
end
