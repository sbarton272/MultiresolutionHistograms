function selectedClasses = pickLikelyClasses(structure, model, consts);

%% Compute prob for each class
numClasses = length(model.allClasses);
prob = zeros(numClasses,2);
prob(:,2) = 1:numClasses; % Class indices to see sorting order
for classIndx = 1:numClasses
	structureProb = model.classes{classIndx}.structureProb;
	%% TODO
end

end