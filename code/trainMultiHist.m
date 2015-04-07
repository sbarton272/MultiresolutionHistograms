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
for classIndx = 1:length(allClasses)

    %% Compute feature vector for every image given the class structure
    classStructure = classStructures{classIndx,1};
    featureVectors = [];
    for imgNo = 1:size(trainLabels, 1);
        I = loadImg(trainImgNames{imgNo}, consts.IMG_DIR);
        % Compute feature vector
        featureVect = computeFeatureVect(I, classStructure, ...
            consts.PRUNING_DEPTH_MAX, consts.WNAME, consts.ENTROPY, 
            consts.NUM_BINS);
        featureVectors = [featureVect featureVectors];
    end

    %% Train an SVM for this class using feature vectors and class labels    
    % Features in col, samples in rows (NxD)
    [svmModel, normMin, normMax] = trainSvm(featureVectors, trainLabels, classLabel, consts);

    %% Package model
    classModel.label = allClasses(i);
    imgInd = find(trainLabels == classModel.label);
    classModel.imgCount = length(imgInd);
    classModel.structure = classStructures{i,1};
    classModel.structureProb = classStructures{i,2};
    classModel.svm = svmModel;
    classModel.normMin = normMin;
    classModel.normMax = normMax;
    model.classes{classIndx} = classModel;

end

end