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
    
%     %% Pick best match
    [~,indexInSelClasses] = max(probabilityOfStructure);
    C = updateCounts(C, testLabels(i), allClasses(indexInSelClasses), allClasses);
    
    if consts.DEBUG
       disp(['Guess: ', num2str(allClasses(indexInSelClasses)), ' (', num2str(testLabels(i)), ')']);
    end
end
end

function C = updateCounts(C, targetLabel, guess, allClasses)
% C(i,j) class i count, predicted j
i = find(allClasses == targetLabel);
j = find(allClasses == guess);
C(i,j) = C(i,j) + 1;
end
