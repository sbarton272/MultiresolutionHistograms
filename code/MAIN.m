%% Multiresolution Histograms

clear all
close all

%% Load data

load('../data/images/traintest.mat', 'train_imagenames', 'train_labels',...
    'test_imagenames', 'test_labels', 'mapping');

%% Training

model = trainMultiHist(train_imagenames, train_labels);

%% Testing

C = evalMultiHist(model, test_imagenames, test_labels, mapping);

%% Save testing results
save('results.mat','C');