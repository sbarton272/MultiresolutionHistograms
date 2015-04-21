clear all
close all

%% Load data

%load('../data/images/traintest.mat', 'train_imagenames', 'train_labels',...
%    'test_imagenames', 'test_labels', 'mapping');

%load('../data/images/traintest.mat');
load('../data/images/devData.mat', 'dev_imagenames', 'dev_labels', 'mapping');
train_imagenames = dev_imagenames;
test_imagenames = dev_imagenames;
train_labels = dev_labels;
test_labels = dev_labels;

%% Add Libraries
addpath('LibSvm-3.20/');
addpath('LibSvm-3.20/matlab');
addpath('LibSvm-3.20/windows');

%% Constants struct
consts.IMG_DIR = '../data/images/';
consts.PRUNING_VAR_THRESH = .1;
consts.PRUNING_DEPTH_MAX = 3;
consts.USE_CLASS_SVM_THRESH = .001;
consts.NB_THRESH = .5;
consts.WNAME = 'haar';
consts.ENTROPY = 'logenergy';
consts.ENT_PARAM = []; % optional
consts.NUM_BINS = 256;
consts.CLASS_STRUCT_VOTE_PROB = .5;
consts.SVM_C = 1;  %C parallel
consts.DEBUG = false;
consts.ZERO_REPLACEMENT = .01;
%% train
allClasses = unique(trainLabels);

model=trainAll(train_imagenames, train_labels, consts,allClasses);
accuracy=testAll(model, test_imagenames, test_labels, consts,allClasses);