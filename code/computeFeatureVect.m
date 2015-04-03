function featureVect = computeFeatureVect(I, structure, depth, wname, entropy)

childrenPerNode = 4;

% Number of bins
numBins = 50;
featureVec = [];

% Compute the full wavelet decomposition
T = wptree(childrenPerNode, depth, I, wname, entropy);

% I has a 1 for all existing nodes
indexes = find(structure == 1) - 1;
leaves = findLeaves(structure, childrenPerNode);

% Walk through the structure vector
for l = leaves
    % Tree indicies in matlab are 0-indexed
    [D, P] = ind2depo([depth, childrenPerNode], l);
    % Reconstruct the image
    image = wprcoef(T, [D P]);
    % Get the histogram, append to feature vector
    [feature, binLocs] = imhist(image, numBins);
    featureVec = [featureVec; feature];
end

end

function [leaves, leafStructure] = findLeaves(structure, childrenPerNode)

%% Extract Leaves
% Iter from tree bottom to top
%   Mark parents as not leaves for all leaves
for i = length(structure):-1:1
    node = structure(i);
    
    % This is a leaf
    if node == 1
        % Mark parents as zeros
        parent = floor((nodeI-1) / childrenPerNode);
        while (parent > 0)
            structure(parent+1) = 0;
            parent = floor((parent-1) / childrenPerNode);
        end
    end
end

%% Find leave locs
leafStructure = structure;
leaves = find(leafStructure) - 1; % Zero indx

end

