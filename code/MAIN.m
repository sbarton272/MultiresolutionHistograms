%% Multiresolution Histograms

clear all
close all

%% Load data

load('../data/images/traintest.mat', 'train_imagenames', 'train_labels',...
    'test_imagenames', 'test_labels', 'mapping');

%% Constants struct

consts.PRUNING_VAR_THRESH = .1;
consts.PRUNING_DEPTH_MAX = 3;
consts.NB_THRESH = .5;
consts.WNAME = 'haar';
consts.ENTROPY = 'shannon';

%% Training

model = trainMultiHist(train_imagenames, train_labels, consts);

%% Testing

C = tesMultiHist(model, test_imagenames, test_labels, mapping, consts);

%% Save testing results
save('results.mat','C');