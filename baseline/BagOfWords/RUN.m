%% Basic functionality test

clear all
close all

addpath('../data');

%% Load image

I = imread('../data/images/airport/sun_aajqjnzswlmdcmyl.jpg');
sz = size(I);
filterBank = createFilterBank();

%figure; imshow(I);

%% Apply filters

filterResponses = extractFilterResponses(I, filterBank);
example = reshape(filterResponses(:,1),sz(1),sz(2));
figure; imagesc(example)
example = reshape(filterResponses(:,15),sz(1),sz(2));
figure; imagesc(example)

%% Run test dictionary

testImgNames = {'sky/sun_aacegqrsghanpufn.jpg', ...
    'auditorium/sun_aadrvlcduunrbpul.jpg', ...
    'campus/sun_acdmqooqscwszayf.jpg'};

% give the absolute path
toProcess = strcat('../data/images/',testImgNames);
[filterBank,dictionary] = getFilterBankAndDictionary(toProcess);

save('testDictionary.mat', 'filterBank', 'dictionary');

%% Run test image mapping

I0 = imread('../data/images/airport/sun_aajqjnzswlmdcmyl.jpg');
I1 = imread(['../data/images/', testImgNames{1}]);
I2 = imread(['../data/images/', testImgNames{2}]);
I3 = imread(['../data/images/', testImgNames{3}]);

wordMapI0 = getVisualWords(I0, filterBank, dictionary);
figure; imagesc(wordMapI0);

wordMapI1 = getVisualWords(I1, filterBank, dictionary);
figure; imagesc(wordMapI1);

wordMapI2 = getVisualWords(I2, filterBank, dictionary);
figure; imagesc(wordMapI2);

wordMapI3 = getVisualWords(I3, filterBank, dictionary);
figure; imagesc(wordMapI3);

%% Test histogram

dictionarySize = size(dictionary);
h = getImageFeatures(wordMapI, dictionarySize(1));

figure; bar(h);

%% Test spatial pyramid histogram

h2 = getImageFeaturesSPM(3, wordMapI, dictionarySize(1));
figure; bar(h2);

%% Test hist dist

histInter = distanceToSet(h2, [h2, h2])


%% Long running stuff

%computeDictionary
%batchToVisualWords()
buildRecognitionSystem



