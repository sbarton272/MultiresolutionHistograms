function [model, normmin, normmax] = trainSvm(trainImgNames, trainLabels,...
	classStructure, classLabel, consts)

%% Compute feature vector for every image given the class structure
featureVectors = [];
for imgNo = 1:size(trainLabels, 1);
    I = loadImg(trainImgNames{imgNo}, consts.IMG_DIR);
    % Compute feature vector
    featureVect = computeFeatureVect(I, classStructure, ...
        consts.PRUNING_DEPTH_MAX, consts.WNAME, consts.ENTROPY,... 
        consts.NUM_BINS);
    featureVectors = [featureVect featureVectors];
end

%% Normalize feature vector
normmin = min(featureVectors);
normmax = max(featureVectors);
 % Zero min
featureVectors = bsxfun(@minus, featureVectors, normmin);
 % Norm to unit len
featureVectors = bsxfun(@times, featureVectors, 1 ./ (normmax - normmin));

%% Caclulate SVM
<<<<<<< HEAD
%opt = sprintf('-c %f -t %d -b %d -q %d ', consts.SVM_C,2, 1, 0);
=======
% TODO options
%opt = sprintf('-c %f -B %d -q %d -t %d', consts.SVM_C, 1, 0, 2);
>>>>>>> b485a573e1f29404a822231bfbd63d3b04f60488
ind = ((trainLabels==classLabel)*2) - 1;
model = svmtrain(featureVectors, ind);

end