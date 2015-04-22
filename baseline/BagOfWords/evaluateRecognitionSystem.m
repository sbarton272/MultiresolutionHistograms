function C = evaluateRecognitionSystem()
% 16720 CV Spring 2015 - Stub Provided
% evaluateRecognitionSystem script here, should output the confusion matrix


%% Constants 
IMG_DIR = '../data/images/';
load('../data/images/traintest.mat', 'test_imagenames', 'test_labels',...
    'mapping');
load('consts.mat');
load('vision.mat');
load('../data/images/traintest.mat','mapping');


%% Run evaluation

nClasses = length(mapping);
C = zeros(nClasses,nClasses);
for i = 1:length(test_imagenames)

    % Load image
    filePath = [IMG_DIR, test_imagenames{i}];
    image = im2double(imread(filePath));
    
    %% Guess image
    wordMap = getVisualWords(image, filterBank, dictionary);
    h = getImageFeaturesSPM( SPM_LAYERS, wordMap, KNN_K);
    distances = distanceToSet(h, train_features);
    [~,nnI] = max(distances);
    
    %% Determine classes
    guess = train_labels(nnI);
    label = test_labels(i);
    
    %% Record guess
    C(label, guess) = C(label, guess) + 1;
    
    disp(['[EVAL] Label: ', mapping{label}, ' Guessed: ', mapping{guess},...
        ' File: ', filePath]);
end

% Print number correct
correct = trace(C) / sum(C(:))

end