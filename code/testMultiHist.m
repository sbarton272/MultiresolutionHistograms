function C = testMultiHist(model, testImgNames, testLabels, consts)

allClasses = unique(testLabels);
numClasses = length(allClasses);
C = zeros(numClasses);

for i=1:length(testImgNames)
    I = loadImg(testImgNames{i}, consts.IMG_DIR);
   
    probabilityList = [];
    for classInd = 1:numClasses
        classModel = model.classes{classInd};

        %% Calculate feature vector
        featureVector = computeFeatureVect(I, ...
                consts.PRUNING_DEPTH_MAX, consts.WNAME,...
                consts.NUM_BINS, consts.DEBUG);

        %% Apply to SVM
        % TODO fix, is normalization handled?
        
        % zeroedFV = bsxfun(@minus, featureVector ,classModel.normmin);
        % featureVector = bsxfun(@times,zeroedFV,1./(classModel.normmax-classModel.normmin));
        
        svmLabel = ((testLabels(i) == classModel.label) * 2) - 1; % Convert label to +-1

        [~, ~, decisionValues] = svmpredict(svmLabel, featureVector', classModel.svm);
        probabilityList = [probabilityList; decisionValues];

     end

    %% Pick best match
    [~,bestMatch] = max(probabilityList);
    C = updateCounts(C, testLabels(i), allClasses(bestMatch), allClasses);
    
    if consts.DEBUG
       disp(['Guess: ', num2str(allClasses(bestMatch)), ' (', num2str(testLabels(i)), ')']);
    end
end
end

function C = updateCounts(C, targetLabel, guess, allClasses)
% C(i,j) class i count, predicted j
i = find(allClasses == targetLabel);
j = find(allClasses == guess);
C(i,j) = C(i,j) + 1;
end
