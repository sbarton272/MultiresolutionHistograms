function [h] = getImageFeatures(wordMap,dictionarySize)
% 16720 CV Spring 2015 - Stub Provided
% Inputs: 
%   wordMap:        Matrix of H x W containing IDs of visual words
%   dictionarySize: number of visual words
% Outputs:
%   histInter: dictionarySize x 1 normalized histogram 

N = histc(reshape(wordMap,[],1), 1:dictionarySize);
h = N/sum(N);

end