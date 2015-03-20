function [histInter] = distanceToSet(wordHist, histograms)
% 16720 CV Spring 2015 - Stub Provided
% Inputs: 
%   wordHist:   Matrix containing histograms computed from all the visual words
%   histograms: Matrix containing histograms from all the training samples 
%               concatenated along the columns
% Outputs:
%   histInter: histogram intersection similarity between wordHist and histograms

mins = bsxfun(@(h1,h2) min(h1,h2), wordHist, histograms); 
histInter = sum(mins);

end