%% 16720 CV Spring 2015 - Stub Provided
% buildRecognitionSystem script here, it sould save a "vision.mat" file

clear all
close all

%% Constants 
OUT_FILE = 'vision.mat';
WORD_MAP_DIR = '../data/wordmaps/';

load('../data/images/traintest.mat', 'train_imagenames', 'train_labels');
load('consts.mat', 'KNN_K', 'SPM_LAYERS');

load('dictionary.mat', 'filterBank', 'dictionary');

%% Extract histograms for all training images

histLen = KNN_K*(4^SPM_LAYERS - 1)/3;
numTrain = length(train_imagenames);
train_features = zeros(histLen, numTrain);

for i = 1:length(train_imagenames)
    filePath = [WORD_MAP_DIR, strrep(train_imagenames{i},'.jpg','.mat')];
    loaded = load(filePath,'wordMap');
    wordMap = loaded.wordMap;
    train_features(:,i) = getImageFeaturesSPM(SPM_LAYERS, wordMap, KNN_K);
    disp(['Features extracted: ', filePath]);
end

%% Save output

save(OUT_FILE, 'filterBank', 'dictionary', 'train_features', ...
    'train_labels');