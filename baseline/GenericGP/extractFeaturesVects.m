function featureVectors = extractFeaturesVects(imageNames, consts)

featureVectors = [];
for imgNo = 1:size(imageNames, 1);
    I = loadImg(imageNames{imgNo}, consts.IMG_DIR);
    % Compute feature vector
    featureVect = ExtractFeatures(I, consts);
    featureVectors = [featureVectors featureVect];
end

featureVectors = featureVectors';

end