function featureVect = computeFeatureVect(I, structure, depth, wname, entropy)

childrenPerNode = 4;

% Number of bins
numBins = 50;
featureVec = [];

% Compute the full wavelet decomposition
T = wptree(childrenPerNode, depth, I, wname, entropy);

% Walk through the structure vector
for i = 1:length(structure)
    % If 1 this is a leaf, we want to use this image
    if (structure(i) == 1)
        % Tree indicies in matlab are 0-indexed
        [D, P] = ind2depo([depth, childrenPerNode], i-1);
        % Reconstruct the image
        image = wprcoef(T, [D P]);
        % Get the histogram, append to feature vector
        [feature, binLocs] = imhist(image, numBins);
        featureVec = [featureVec; feature];
    end
    
end

end