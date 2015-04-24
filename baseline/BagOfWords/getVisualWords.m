function wordMap = getVisualWords(I, filterBank, dictionary)
% 16720 CV Spring 2015 - Stub Provided
% Inputs: 
%   I:     RGB Image with dimensions Rows x Cols (e.g. ouput from calling imread)
%   filterBank: Output from getFilterBankAndDictionary()
%   dictionary: Output from getFilterBankAndDictionary()
% Outputs:
%   wordMap:  matrix with dimensions Rows x Cols

%% Filter and distances
filterResponses = extractFilterResponses(I, filterBank);
D = pdist2(filterResponses, dictionary);
% TODO maps simply to index
[~, mappedI] = min(D, [], 2);
sz = size(I);
wordMap = reshape(mappedI, sz(1), sz(2));

end