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
model.trainImgNames = trainImgNames;
model.trainLabels = trainLabels;
model.allClasses = allClasses;

%% Compute class structures
classStructures = computeClassStructures(trainImgNames, trainLabels, consts);

%% Feature extraction for all images
for classIndx = 1:length(allClasses)
    classLabel = allClasses(classIndx);

    %% Train an SVM for this class using feature vectors and class labels    
    % Features in col, samples in rows (NxD)
    [svmModel, normMin, normMax] = trainSvm(trainImgNames, trainLabels,...
        classStructures{classIndx,1}, classLabel, consts);

    %% Package model
    classModel.label = classLabel;
    imgInd = find(trainLabels == classModel.label);
    classModel.imgCount = length(imgInd);
    classModel.structure = classStructures{classIndx,1};
    classModel.structureProb = classStructures{classIndx,2};
    classModel.svm = svmModel;
    classModel.normMin = normMin;
    classModel.normMax = normMax;
    model.classes{classIndx} = classModel;

end

end