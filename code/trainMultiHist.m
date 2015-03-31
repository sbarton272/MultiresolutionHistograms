function model = trainMultiHist(trainImgNames, trainLabels, consts)

%% Compute class structures
% This creates two matrices: 
% classStructures -- a matrix where column i is the ideal breakdown of
%   class i
% classProbs -- a matrix where each column i is the probability vector of
%   class i. The probability vector has, for each element, the probability
%   that a vector in that class has a 1 in that element. It is determined
%   from the training data

classStructureVotingProb = 0.5;
classStructures = [];
classProbs = [];

for class
    classDecomps = []; % All image decompositions just for this class
    for img
    %% Compute structure
    structure = computeStructure(I, consts.PRUNING_DEPTH_MAX,...
        consts.PRUNING_VAR_THRESH);
    classDecomps = [classDecomps structure];
    end
    
    %% Determine NB prob for this class
    [vectorLen, classImages] = size(classDecomps);
    classImages = double(classImages);
    classProb = zeros(vectorLen, 1);
    for i = 1:vectorLen
        classProb(i) = sum(classDecomps(i,:))/classImages;
    end
    classProbs = [classProbs classProb];
    
    %% Determine class structure for this class
    classStructure = classProb > classStructureVotingProb;
    classStructures = [classStructures classStructure];
    
end

%% Feature extraction for all images
for class
    classStructure = classStructures(:,class);
    for img
    
        %% Compute feature vector
        featureVect = computeFeatureVect(I, classStructure);
        
    end
end

%% Train SVM per class


%% Package model

end