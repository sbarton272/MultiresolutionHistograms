function [dec histLvls] = plotwavelet2(C,S,level,wavelet,rv,bins)

%   Plot wavelet image (2D) decomposition.
%   A short and simple function for displaying wavelet image decomposition
%   coefficients in 'tree' or 'square' mode
%
%   Required : MATLAB, Image Processing Toolbox, Wavelet Toolbox
%
%   plotwavelet2(C,S,level,wavelet,rv,mode)
%
%   Input:  C : wavelet coefficients (see wavedec2)
%           S : corresponding bookkeeping matrix (see wavedec2)
%           level : level decomposition 
%           wavelet : name of the wavelet
%           rv : rescale value, typically the length of the colormap
%                (see "Wavelets: Working with Images" documentation)
%           mode : 'tree' or 'square'
%
%   Output:  none
%
%   Example:
%
%     % Load image
%     load wbarb;
%     % Define wavelet of your choice
%     wavelet = 'haar';
%     % Define wavelet decomposition level
%     level = 2;
%     % Compute multilevel 2D wavelet decomposition
%     [C S] = wavedec2(X,level,wavelet);
%     % Define colormap and set rescale value
%     colormap(map); rv = length(map);
%     % Plot wavelet decomposition using square mode
%     plotwavelet2(C,S,level,wavelet,rv,'square');
%     title(['Decomposition at level ',num2str(level)]);
%
%
%   Benjamin Tremoulheac, benjamin.tremoulheac@univ-tlse3.fr, Apr 2010

A = cell(1,level); H = A; V = A; D = A;

for k = 1:level
    A{k} = appcoef2(C,S,wavelet,k); % approx
    [H{k} V{k} D{k}] = detcoef2('a',C,S,k); % details  
    
    A{k} = wcodemat(A{k},rv);
    H{k} = wcodemat(H{k},rv);
    V{k} = wcodemat(V{k},rv);
    D{k} = wcodemat(D{k},rv);
end

dec = cell(1,level);
histLvls = cell(1,level);

dec{level} = [A{level} H{level} ; V{level} D{level}];
histLvls{level} = [histNorm(A{level}, bins), histNorm(H{level}, bins), ...
    histNorm(V{level}, bins), histNorm(D{level}, bins)];

for k = level-1:-1:1
    dec{k} = [imresize(dec{k+1},size(H{k})) H{k} ; V{k} D{k}];
    histLvls{k} = [histNorm(H{k}, bins), ...
        histNorm(V{k}, bins), histNorm(D{k}, bins)];
end

figure; colormap('gray'); image(dec{1});

figure;
N = 2^level-1;

H = histLvls{level};
subplot(N,N,1); plt(bins,H(:,1));
subplot(N,N,2); plt(bins,H(:,2));
subplot(N,N,N+1); plt(bins,H(:,3));
subplot(N,N,N+2); plt(bins,H(:,4));

for k = 1:level-1
    H = histLvls{k};
    offset = 2^(level-k);
    subplot(N,N,offset+1); plt(bins,H(:,1));
    subplot(N,N,N*offset+1); plt(bins,H(:,2));
    subplot(N,N,N*offset+offset+1); plt(bins,H(:,3));
end


end

function plt(bins,h)
    bar(bins,log(h));  xlim([-.1 1.1]); xlabel('intensity'); 
    ylabel('counts (log)');
end

function h = histNorm(x,bins)
    h = histc(x(:)/256, bins);
end