function [model, normmin, normmax] = trainSvm(featureVectors, trainLabels, classLabel, consts)

%% Normalize feature vector
normmin = min(featureVectors);
normmax = max(featureVectors);
 % Zero min
featureVectors = bsxfun(@minus, featureVectors, normmin);
 % Norm to unit len
featureVectors = bsxfun(@times, featureVectors, 1 / (normmax - normmin));

%% Caclulate SVM
opt = sprintf('-c %f -B %d -q %d -t %d', consts.SVM_C, 1, 0, 2);
ind = ((trainLabels==classLabel)*2) - 1;
model = svmtrain(ind, featureVectors, opt);

end