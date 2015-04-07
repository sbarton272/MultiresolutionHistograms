function C = testMultiHist(model, testImgNames, testLabels,...
    labelMapping, consts)

numImgs = size(testImgNames,1);
numClasses = length(model.allClasses);
C = zeros(numClasses);
for i = 1:numImgs
	
	I = loadImg(testImgNames{i}, consts.IMG_DIR);
	label = classifyImg(I, model, consts);
	C = updateCounts(testLabels{i}, lable, allClasses);

end
end

function C = updateCounts(C, targetLabel, guess, allClasses)
% C(i,j) class i count, predicted j
i = find(allClasses == targetLabel);
j = find(allClasses == guess);
C(i,j) = C(i,j) + 1;
end
