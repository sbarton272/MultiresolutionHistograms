function model = trainMultiHist(trainImgNames, trainLabels, consts)
% Note: this functions assumes that trainImgNames has all images for class
% 1 first, all images for class 2 after, etc etc


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

numClasses = length(unique(trainLabels));

name_loc = 1;
for class = 1:numClasses
    classDecomps = []; % All image decompositions just for this class
    for imgNo = 1:sum(trainLabels == class);
        I = imread(trainImgNames{name_loc});
        name_loc = name_loc + 1;
        % Compute structure
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
for class = 1:length(unique(trainLabels))
    % Compute feature vector for every image given the class structure
    classStructure = classStructures(:,class);
    featureVectors = [];
    for imgNo = 1:size(trainLabels, 1);
        I = imread(trainImgNames{imageNo});
        % Compute feature vector
        featureVect = computeFeatureVect(I, classStructure, ...
            consts.PRUNING_DEPTH_MAX, consts.WNAME, consts.ENTROPY);
        featureVectors = [featureVect featureVectors];
    end
    
    % Train an SVM for this class using feature vectors and class labels
end


%% Package model
% Include class structures, class probs, and all the svms

end