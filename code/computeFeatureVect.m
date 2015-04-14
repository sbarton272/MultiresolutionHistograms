function featureVec = computeFeatureVect(I, structure, depth, wname,...
    entropy, numBins, verbose)

childrenPerNode = 4;

% Compute the full wavelet decomposition
T = wptree(childrenPerNode, depth, I, wname, entropy);

% I has a 1 for all existing nodes
leaves = findLeaves(structure, childrenPerNode);

% Walk through the structure vector
numLeaves = length(leaves);
featureVec = zeros(numLeaves*numBins,1);
if verbose
    pltN = ceil(sqrt(numLeaves));
    figure;
end
for i = 1:numLeaves
    l = leaves(i);
    
    % Tree indicies in matlab are 0-indexed
    [D, P] = ind2depo(childrenPerNode, l);
    
    % Reconstruct the image
    image = wprcoef(T, [D P]);

    % Get the histogram, append to feature vector
    start = numBins*(i-1)+1;
    h = normHist(image, numBins);
    featureVec(start:start+numBins-1) = h;
    
    if verbose
       subplot(pltN,pltN,i); bar(-log(h)); title([num2str(D),',',num2str(P)]);
       set(gca,'xtick',[])
       set(gca,'xticklabel',[])
       set(gca,'ytick',[])
       set(gca,'yticklabel',[])
    end
    
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

