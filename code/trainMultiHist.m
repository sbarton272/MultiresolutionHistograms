function model = trainMultiHist(trainImgNames, trainLabels, consts)
% Note: this functions assumes that trainImgNames has all images for class
% 1 first, all images for class 2 after, etc etc

%% Model object
% Include class structures, class probs, and all the svms
% class obj
% - label
% - structure
% - count of training images
% - structure probabilities
% - class svm
allClasses = unique(trainLabels);
model.classes = cell(length(allClasses),1);

%% Compute class structures
classStructures = computeClassStructures(trainImgNames, trainLabels, consts);

%% Feature extraction for all images
allClasses = unique(trainLabels);
for classIndx = 1:length(allClasses)
    % Compute feature vector for every image given the class structure
    classStructure = classStructures{classIndx};
    featureVectors = [];
    for imgNo = 1:size(trainLabels, 1);
        I = imread(trainImgNames{imageNo});
        % Compute feature vector
        featureVect = computeFeatureVect(I, classStructure, ...
            consts.PRUNING_DEPTH_MAX, consts.WNAME, consts.ENTROPY);
        featureVectors = [featureVect featureVectors];
    end
    
    % Features in col, samples in rows (NxD)

    % Train an SVM for this class using feature vectors and class labels
    % TODO DUSTIN
end

%% Package model
for classIndx = 1:length(allClasses)
    classModel.label = allClasses(i);
    imgInd = find(trainLabels == classModel.label);
    classModel.imgCount = length(imgInd);
    classModel.structure = classStructures{i,1};
    classModel.structureProb = classStructures{i,2};
    classModel.svm = {}
    model.classes{classIndx} = classModel;
end

end