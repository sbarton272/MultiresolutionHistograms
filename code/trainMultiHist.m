function model = trainMultiHist(trainImgNames, trainLabels, consts)

%% Compute class structures

for class
    for img
    %% Compute structure
    structure = computeStructure(I, consts.PRUNING_DEPTH_MAX,...
        consts.WNAME, consts.ENTROPY, consts.ENT_PARAM, true);
    end
    %% Determine class structure

    %% Determine NB prob
    
end

%% Feature extraction for all images
for class
    for img
    
        %% Compute feature vector
        featureVect = computeFeatureVect(I, classStructure);
        
    end
end

%% Train SVM per class


%% Package model

end