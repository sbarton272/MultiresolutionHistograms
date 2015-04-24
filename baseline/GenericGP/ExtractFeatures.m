function featureVect=ExtractFeatures(image)
descentDepth=3;
numBins=256;
featureVect=[];
currentImg=rgb2gray(image);
[feature, binLocs] = imhist(currentImg, numBins);
featureVect = [featureVect; feature];
for i=1:descentDepth+1
    currentImg= impyramid(currentImg, 'expand');
    allImages{i} = currentImg;
    [feature, binLocs] = imhist(currentImg, numBins);
    featureVect = [featureVect; feature];
end

end