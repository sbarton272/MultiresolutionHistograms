function imgEntropy(img)

I1 = rgb2gray(im2double(imread(img)));
I = I1;
figure; subplot(2,1,1); imshow(I); subplot(2,1,2); hist(I(:),256);
h = hist(I(:),256);
e = entropyHist(h)
p0 = sum(h.^2)
title(num2str(e));

H = fspecial('gaussian',5,1);
I = imfilter(I1,H);

figure; subplot(2,1,1); imshow(I); subplot(2,1,2); hist(I(:),256);
h = hist(I(:),256);
e = entropyHist(h)
p1 = sum(h.^2)/p0
title(num2str(e));

%H = fspecial('laplacian',1);
H = padarray(2,[2 2]) - fspecial('gaussian' ,[5 5],2);
H = H / norm(H);
I = imfilter(I1,H);
I = I - min(I(:));
I = I / max(I(:));

figure; subplot(2,1,1); imshow(I); subplot(2,1,2); hist(I(:),256);
h = hist(I(:),256);
e = entropyHist(h)
p2 = sum(h.^2)/p0
p1 / p2
title(num2str(e));

end

function e = entropyHist(h)

    h = h / sum(h);
    e = h.*log(h);
    e(isnan(e)) = 0;
    e = -sum(e);

end