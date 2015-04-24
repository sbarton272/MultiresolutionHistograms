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
        probabilityOfStructure(classind)= log(prod(prob));
    end
    
    % Do a transformation to make the smallest negative large
    % and the largest negatives small
    probabilityOfStructure(probabilityOfStructure < -120) = -120;
    probabilityOfStructure = 120 - abs(probabilityOfStructure);
    
    %% Selecte classes so that it represents up to .5 of the total probability
    totalProb = sum(probabilityOfStructure);
    probsLeft = probabilityOfStructure; % Probs we have not selected already
    selectedProbs = 0; % Sum of selected probs
    selectedClasses = []; % The classes we will test
    while (selectedProbs < .5*totalProb)
        maxProb = max(probsLeft); % Max remaining class prob
        selectedProbs = selectedProbs + sum(maxProb); % Add to running total
        % Add class of max prob to class list
        classToAdd = find(probabilityOfStructure == maxProb);
        selectedClasses = [selectedClasses classToAdd];
        probsLeft(probsLeft == maxProb) = [];
    end
   
    %% Test on SVMs
    probabilityList=[];
    for classInd = selectedClasses
        classModel = model.classes{classInd};

        %% Calculate feature vector
        featureVector = computeFeatureVect(I, classModel.structure, ...
                consts.PRUNING_DEPTH_MAX, consts.WNAME, consts.ENTROPY,...
                consts.NUM_BINS, consts.DEBUG);

        %% Apply to SVM
        % TODO fix, is normalization handled?

        
%         zeroedFV=bsxfun(@minus, featureVector ,classModel.normmin);
%         
%         
%         featureVector=bsxfun(@times,zeroedFV,1./(classModel.normmax-classModel.normmin));
%         keyboard;

%         svmLabel = ((testLabels(i) == classModel.label) * 2) - 1; % Convert label to +-1
% 
%         [predictedLabel, accuracy, decisionValues] = svmpredict(svmLabel, featureVector', classModel.svm);
%         probabilityList = [probabilityList; decisionValues];
% 
     end
% 
%     %% Pick best match
%     [~,indexInSelClasses] = max(probabilityList);
%     BestMatch=selectedClasses(indexInSelClasses);
%     C = updateCounts(C, testLabels(i), allClasses(BestMatch), allClasses);
%     
%     if consts.DEBUG
%        disp(['Guess: ', num2str(allClasses(BestMatch)), ' (', num2str(testLabels(i)), ')']);
%     end
    end

end

function C = updateCounts(C, targetLabel, guess, allClasses)
% C(i,j) class i count, predicted j
i = find(allClasses == targetLabel);
j = find(allClasses == guess);
C(i,j) = C(i,j) + 1;
end
