function featureVect = computeFeatureVect(I, structure, depth, wname, entropy)

childrenPerNode = 4;

% Number of bins
numBins = 50;
featureVec = [];

% Compute the full wavelet decomposition
T = wptree(childrenPerNode, depth, I, wname, entropy);

% I has a 1 for all existing nodes
indexes = find(structure == 1) - 1;
leaves = [];
% FIND LEAVES

% Walk through the structure vector
for i = leaves
    % leaf index in
    if (any(i == indxes))
        % Tree indicies in matlab are 0-indexed
        [D, P] = ind2depo([depth, childrenPerNode], i);
        % Reconstruct the image
        image = wprcoef(T, [D P]);
        % Get the histogram, append to feature vector
        [feature, binLocs] = imhist(image, numBins);
        featureVec = [featureVec; feature];
    end
    
end

end