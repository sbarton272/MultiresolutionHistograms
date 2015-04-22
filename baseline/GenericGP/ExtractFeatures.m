function featureVect = ExtractFeatures(image, consts)
featureVect = [];
currentImg = rgb2gray(image);

% Get gaussian levels
[feature, ~] = imhist(currentImg, consts.NUM_BINS);
featureVect = [featureVect; feature];
for i=1:consts.PYRAMID_DEPTH
    currentImg = impyramid(currentImg, 'reduce');
    [feature, ~] = imhist(currentImg, consts.NUM_BINS);
    featureVect = [featureVect; feature];
end

end