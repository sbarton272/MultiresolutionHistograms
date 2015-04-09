function classStructures = computeClassStructures(trainImgNames, trainLabels, consts)
%% Compute class structures
% This creates two matrices which are combined in one cell array: 
% classStructures -- a matrix where column i is the ideal breakdown of
%   class i
% classProbs -- a matrix where each column i is the probability vector of
%   class i. The probability vector has, for each element, the probability
%   that a vector in that class has a 1 in that element. It is determined
%   from the training data

allClasses = unique(trainLabels);
classStructures = cell(length(allClasses),2);

% Iter all classes
for i = 1:length(allClasses)
	classNo = allClasses(i);

    classIndices = find(trainLabels == classNo);
    % All image decompositions just for this class
    classDecomps = [];

   	% Iter all images in class
    for imgIndx = classIndices';
        I = loadImg(trainImgNames{imgIndx}, consts.IMG_DIR);
        % Compute structure
        structure = computeStructure(I, consts.PRUNING_DEPTH_MAX,...
            consts.WNAME, consts.ENTROPY, consts.ENT_PARAM, consts.DEBUG);
        classDecomps = [classDecomps structure];
    end
    
    %% Determine NB prob for this class
    [vectorLen, classImages] = size(classDecomps);
    classImages = double(classImages);
    classProb = sum(classDecomps,2)/classImages;
    classProb(classProb == 0) = consts.ZERO_REPLACEMENT;
    classStructures{i,2} = classProb;
    
    %% Determine class structure for this class
    classStructure = classProb > consts.CLASS_STRUCT_VOTE_PROB;
    classStructures{i,1} = classStructure;
    
end

end