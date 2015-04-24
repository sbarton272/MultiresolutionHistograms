%% Evaluate on all testing images

clear all
close all

%% Constants 
IMG_DIR = '../data/images/';
load('../data/images/traintest.mat', 'test_imagenames', 'test_labels',...
    'mapping');
load('consts.mat');
load('vision.mat');
load('../data/images/traintest.mat','mapping');


%% Run evaluation

correct = 0;
for i = 1:length(test_imagenames)

    % Load image
    filePath = [IMG_DIR, test_imagenames{i}];
    image = im2double(imread(filePath));
    
    %% Guess image
    wordMap = getVisualWords(image, filterBank, dictionary);
    h = getImageFeaturesSPM( SPM_LAYERS, wordMap, KNN_K);
    distances = distanceToSet(h, train_features);
    [~,nnI] = max(distances);
    guessedImage = mapping{train_labels(nnI)};
    
    %% Check guess
    label = mapping{test_labels(i)};
    if strcmp(guessedImage, label) == 1
       correct = correct + 1; 
    end
    disp(['[EVAL] Label: ', label, ' Guessed: ', guessedImage,...
        ' File: ', filePath]);
end

fprintf('[Percent correct]:%n.\n', correct / length(test_imagenames));