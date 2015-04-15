function [model,normmin,normmax] = trainSvm(trainImgNames, trainLabels,...
	classStructure, classLabel, consts)

%% Compute feature vector for every image given the class structure
featureVectors = [];
for imgNo = 1:size(trainLabels, 1);
    I = loadImg(trainImgNames{imgNo}, consts.IMG_DIR);
    % Compute feature vector
    featureVect = computeFeatureVect(I, classStructure, ...
        consts.PRUNING_DEPTH_MAX, consts.WNAME, consts.ENTROPY,... 
        consts.NUM_BINS);
    featureVectors = [featureVectors featureVect];
end

%% Caclulate SVM
opt = sprintf('-t %d -c %f -b %d -q %d', 2, consts.SVM_C, 1, 0);
lables = ((trainLabels==classLabel)*2) - 1; % Convert lables from 1,0 to +-1

normmin=min(featureVectors')';
normmax=max(featureVectors')';
normmax(find(normmax==normmin))=normmax(find(normmax==normmin))+1;
zeroedFV=bsxfun(@minus, featureVectors ,normmin);

featureVectors=bsxfun(@times,zeroedFV,1./(normmax-normmin));
model = svmtrain(lables, featureVectors', opt);

end
