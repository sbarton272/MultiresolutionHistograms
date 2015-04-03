%% Multiresolution Histograms

clear all
close all

%% Load data

load('../data/images/traintest.mat', 'train_imagenames', 'train_labels',...
    'test_imagenames', 'test_labels', 'mapping');

%% Add Libraries

addpath('LibSvm-3.20/matlab');

%% Constants struct

consts.PRUNING_VAR_THRESH = .1;
consts.PRUNING_DEPTH_MAX = 3;
consts.NB_THRESH = .5;
consts.WNAME = 'haar';
consts.ENTROPY = 'shannon';
consts.ENT_PARAM = []; % optional
<<<<<<< Updated upstream
consts.CLASS_STRUCT_VOTE_PROB = 0.5;
=======
consts.svmC=1;  %C parallel
>>>>>>> Stashed changes

%% Training

model = trainMultiHist(train_imagenames, train_labels, consts);

%% Testing

C = tesMultiHist(model, test_imagenames, test_labels, mapping, consts);

%% Save testing results
save('results.mat','C');
