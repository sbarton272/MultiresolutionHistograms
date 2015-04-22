function [filterBank, dictionary] = getFilterBankAndDictionary(image_names)
% 16720 CV Spring 2015 - Stub Provided
% Inputs: 
%   image_names: cell array of strings (full path to images)
% Outputs:
%   filterBank:  a cell array of N filters
%   dictionary:  \alpha x K matrix 

%% Load program consts
load('consts.mat', 'KNN_K', 'N_RND_SMPLS')
nTrainImgs = length(image_names);

%% Filters
filterBank = createFilterBank();
nFltrs = length(filterBank);

%% Get filter responses

allFilterResponses = zeros(N_RND_SMPLS*nTrainImgs, 3*nFltrs);
for nameI = 0:nTrainImgs-1
    
    I = imread(image_names{nameI+1});
    
    % Indices for sampling, TODO better way?
    sz = size(I);
    sampleInd = randperm(sz(1)*sz(2), N_RND_SMPLS);
    
    filterResponses = extractFilterResponses(I, filterBank);
    row = nameI*N_RND_SMPLS;
    allFilterResponses(row+1:row+N_RND_SMPLS,:) = filterResponses(sampleInd,:);
    
end

%% Perform KMeans

[~, dictionary] = kmeans(allFilterResponses, KNN_K, 'EmptyAction', 'drop');

end