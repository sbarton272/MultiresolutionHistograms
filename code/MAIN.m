%% Multiresolution Histograms

clear all
close all

%% Load data

%load('../data/images/traintest.mat', 'train_imagenames', 'train_labels',...
%    'test_imagenames', 'test_labels', 'mapping');

load('../data/images/devData.mat', 'dev_imagenames', 'dev_labels', 'mapping');
train_imagenames = dev_imagenames;
test_imagenames = dev_imagenames;
train_labels = dev_labels;
test_labels = dev_labels;

%% Add Libraries
addpath('LibSvm-3.20/matlab');

%% Constants struct
consts.IMG_DIR = '../data/images/';
consts.PRUNING_VAR_THRESH = .1;
consts.PRUNING_DEPTH_MAX = 1;
consts.NB_THRESH = .5;
consts.WNAME = 'haar';
consts.ENTROPY = 'logenergy';
consts.ENT_PARAM = []; % optional
consts.NUM_BINS = 256;
consts.CLASS_STRUCT_VOTE_PROB = 0.5;
consts.SVM_C = 1;  %C parallel
consts.DEBUG = true;

%% Training
model = trainMultiHist(train_imagenames, train_labels, consts);

%% Testing
C = tesMultiHist(model, test_imagenames, test_labels, mapping, consts);

%% Save testing results
save('results.mat','C');
