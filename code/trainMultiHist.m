function model = trainMultiHist(trainImgNames, trainLabels, mapping, consts)
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

%% Feature extraction for all images
for classIndx = 1:length(allClasses)
    classLabel = allClasses(classIndx);

    %% Train an SVM for this class using feature vectors and class labels    
    % Features in col, samples in rows (NxD)
    [svmModel,normmin,normmax] = trainSvm(trainImgNames, trainLabels,...
        classLabel, consts);

    %% Package model
    classModel.label = classLabel;
    classModel.name = mapping{classLabel};
    imgInd = find(trainLabels == classModel.label);
    classModel.imgCount = length(imgInd);
    classModel.svm = svmModel;
    classModel.normmin=normmin;
    classModel.normmax=normmax;
    model.classes{classIndx} = classModel;


end

end