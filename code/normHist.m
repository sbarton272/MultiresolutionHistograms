function h = normHist(I, binSize)

% Case on dimension
if size(I,3) == 3
   I = rgb2gray(I); 
end

h = imhist(I, binSize);
h = h / sum(h);

end