% Yiying Li for CV Spring 2015
% Does computation of the filter bank and dictionary, and saves
% it in dictionary.mat

load('../data/images/traintest.mat');
% give the absolute path
to_process = strcat(['../data/images/'],train_imagenames);
[filterBank,dictionary] = getFilterBankAndDictionary(to_process);
save('dictionary.mat','filterBank','dictionary');
clear to_process
