function C = testMultiHist(model, testImgNames, testLabels, consts)

allClasses = unique(testLabels);
numClasses = length(allClasses);
C = zeros(numClasses);

for i=1:length(testImgNames)
    I = loadImg(testImgNames{i}, consts.IMG_DIR);
    
%% Extract structure
structure = computeStructure(I, consts.PRUNING_DEPTH_MAX,...
            consts.WNAME, consts.ENTROPY, consts.ENT_PARAM, consts.DEBUG);

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
for classInd = selectedClasses
    classModel = model.classes{classInd};

    %% Calculate feature vector
    featureVector = computeFeatureVect(I, classModel.structure, ...
            consts.PRUNING_DEPTH_MAX, consts.WNAME, consts.ENTROPY,...
            consts.NUM_BINS);

    %% Apply to SVM
    % TODO fix, is normalization handled?
    [predictedLabel, accuracy, decisionValues] = svmpredict(featureVector, classModel.svm);
    probabilityList = [probabilityList decisionValues];
    
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
