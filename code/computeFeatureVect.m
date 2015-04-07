function featureVec = computeFeatureVect(I, structure, depth, wname,...
    entropy, numBins)

childrenPerNode = 4;

% Number of bins
featureVec = [];

% Compute the full wavelet decomposition
T = wptree(childrenPerNode, depth, I, wname, entropy);

% I has a 1 for all existing nodes
leaves = findLeaves(structure, childrenPerNode);

% Walk through the structure vector
for l = leaves
    % Tree indicies in matlab are 0-indexed
    [D, P] = ind2depo(childrenPerNode, l);
    % Reconstruct the image
    image = wprcoef(T, [D P]);
    % Get the histogram, append to feature vector
    [feature, binLocs] = imhist(rgb2gray(image), numBins);
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
        parent = floor((i-1) / childrenPerNode);
        while (parent > 0)
            structure(parent+1) = 0;
            parent = floor((parent-1) / childrenPerNode);
        end
    end
end

%% Find leave locs
leafStructure = structure;
leaves = find(leafStructure) - 1; % Zero indx
leaves = leaves';

end

