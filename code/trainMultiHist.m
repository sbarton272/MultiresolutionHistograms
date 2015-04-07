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
        I = imread(trainImgNames{imgNo});
        % Compute feature vector
        featureVect = computeFeatureVect(I, classStructure, ...
            consts.PRUNING_DEPTH_MAX, consts.WNAME, consts.ENTROPY);
        featureVectors = [featureVect featureVectors];
    end

    
    % Features in col, samples in rows (NxD)


    normmin=min(featureVectors);
    normmax=max(featureVectors);
    featureVectors=(featureVectors-repmat(min(featureVectors),[size(featureVectors,1) 1]))./(repmat(max(featureVectors)-min(featureVectors),[size(featureVectors,1) 1]));
    opt= sprintf('-c %f -B %d -q %d -t %d', consts.svmC, 1, 0, 2);
    model = svmtrain(((trainLabels==class)*2)-1,featureVectors ,opt );

    % Train an SVM for this class using feature vectors and class labels
  
end

%% Package model
for i = 1:length(allClasses)
    classModel.label = allClasses(i);
    imgInd = find(trainLabels == classModel.label);
    classModel.imgCount = length(imgInd);
    classModel.structure = classStructures{i,1};
    classModel.structureProb = classStructures{i,2};
    classModel.svm = {};
    model.classes{i} = classModel;
end

end