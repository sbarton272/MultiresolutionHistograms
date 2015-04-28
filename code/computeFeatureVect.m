function featureVec = computeFeatureVect(I, depth, wname,...
    numBins, verbose)

childrenPerNode = 4;

% Compute the full wavelet decomposition
wpt = wpdec2(I,depth,wname);
wt = wp2wtree(wpt);

% Walk through the structure vector
leafNodes = leaves(wt);
numLeaves = length(leafNodes);
featureVec = zeros(numLeaves*numBins,1);
if verbose
    pltN = ceil(sqrt(numLeaves));
    figure;
end
for i = 1:numLeaves
    l = leafNodes(i);
    
    % Tree indicies in matlab are 0-indexed
    [D, P] = ind2depo(childrenPerNode, l);
    
    % Reconstruct the image
    image = wprcoef(wt, [D P]);

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