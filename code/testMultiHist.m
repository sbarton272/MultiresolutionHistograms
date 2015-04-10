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
    probabilityOfStructure=zeros(1,numClasses);
    for classind=1:numClasses
        structureProb = model.classes{classind}.structureProb;
        prob = structureProb .* (structure == 1) + (1-structureProb) .* (structure == 0);
        probabilityOfStructure(classind)= sum(log(prob));
    end
    selectedClasses = find(probabilityOfStructure>=log(consts.USE_CLASS_SVM_THRESH));

    % If nothing above the threshold, try everything
    if isempty(selectedClasses)
        selectedClasses = 1:numClasses;
    end

    %% Test on SVMs
    probabilityList=[];
    for classInd = selectedClasses
        classModel = model.classes{classInd};

        %% Calculate feature vector
        featureVector = computeFeatureVect(I, classModel.structure, ...
                consts.PRUNING_DEPTH_MAX, consts.WNAME, consts.ENTROPY,...
                consts.NUM_BINS);

        %% Apply to SVM
        % TODO fix, is normalization handled?
        svmLabel = (testLabels(i) == classModel.label) * 2 - 1; % Convert label to +-1
        [predictedLabel, accuracy, decisionValues] = svmpredict(svmLabel, featureVector', classModel.svm);
        probabilityList = [probabilityList; decisionValues];

    end

    %% Pick best match
    [~,indexInSelClasses] = max(probabilityList);
    BestMatch=selectedClasses(indexInSelClasses);
    C = updateCounts(C, testLabels(i), allClasses(BestMatch), allClasses);
    
    if consts.DEBUG
       disp(['Guess: ', num2str(allClasses(BestMatch)), ' (', num2str(testLabels(i)), ')']);
    end
end

end

function C = updateCounts(C, targetLabel, guess, allClasses)
% C(i,j) class i count, predicted j
i = find(allClasses == targetLabel);
j = find(allClasses == guess);
C(i,j) = C(i,j) + 1;
end
