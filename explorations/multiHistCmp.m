%% Comparison of multiresolution histograms

clear all;
close all;

addpath('plotwavelet2');

%% Consts
HSIZE = 20;
SIGMA = 5;
LEVELS = 2;
BUCKETS = linspace(0,1,256);
WAVELET = 'db5';

%% Load
[I, map] = imread('shapes.png');
I = rgb2gray(im2double(I));

%% Gaussian pyramid
gaussI = cell(1,LEVELS+1);
blurred = I;
figure;
for level = 1:LEVELS+1
    sigma = SIGMA^(level - 1);
    
    % Store
    gaussI{level}.img = blurred;
    gaussI{level}.hist = histc(blurred(:), BUCKETS);
    
    % Plot
    row = 2*(level-1);
    subplot(LEVELS+1,2,row+1);
    imshow(blurred); title(['Gaussian Level:', num2str(level), ' Sigma:', num2str(sigma)])
    subplot(LEVELS+1,2,row+2);
    bar(BUCKETS, log(gaussI{level}.hist)); xlim([-.1 1.1]); xlabel('intensity'); ylabel('counts (log)');
    
    % Blur next level
    gauss = fspecial('gaussian', HSIZE, sigma);
    blurred = imfilter(blurred,gauss,'replicate');
end

%% Wavelet decomp

[C S] = wavedec2(I,LEVELS,WAVELET);
map = colormap('gray'); rv = length(map);
[dec, histLvls] = plotWaveletHist(C,S,LEVELS,WAVELET,rv,BUCKETS);

