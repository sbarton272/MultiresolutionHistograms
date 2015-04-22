function h = getImageFeaturesSPM(layerNum, wordMap, dictionarySize)
% 16720 CV Spring 2015 - Stub Provided
% Inputs: 
%   layerNum:       number of layers, >= 1
%   wordMap:        Matrix of H x W containing IDs of visual words
%   dictionarySize: number of visual words
% Outputs:
%   histInter: normalized histogram vector

% TODO save computation by finding lowest layer and adding to solve higher
% layers

sz = size(wordMap);

%% Layer index, starts at zero
L = layerNum - 1;

%% Pre-alloc hist
h = zeros(dictionarySize*(4^(L+1) - 1)/3, 1);

%% Layer 0, weighted 2^(-L)
h0 = getImageFeatures(wordMap, dictionarySize);
h0 = h0*2^(-L);
h(1:dictionarySize) = h0;

%% Layers 1 onwards
l = 1;
fltI = 1;
while l <= L
    
    cellW = floor(sz(2) / 2^l);
    cellH = floor(sz(1) / 2^l);
    weight = 2^(l - L - 1)*4^(-l);
    
    % Split into regions
    for x = 0:(2^l-1)
        for y = 0:(2^l-1)
            cell = wordMap(y*cellH+1:(y+1)*cellH, x*cellW+1:(x+1)*cellW);
            hst = getImageFeatures(cell, dictionarySize);
            
            % Update output hist
            h(fltI*dictionarySize+1:(fltI+1)*dictionarySize) = hst*weight;
            fltI = fltI + 1;
        end
    end
    
    % Iterate to next layer
    l = l + 1;
end

end


