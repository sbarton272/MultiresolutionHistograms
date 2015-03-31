function waveletFlt(X, levels, map, filter)

if isempty(filter)
   filter = 'sym4'; 
end

% Image coding.
nbcol = size(map,1);
if ~isempty(map)
    cod_X = wcodemat(X,nbcol);
else
    cod_X = X;
end

% Visualize the original image.
subplot(221)
image(X)
title('Original image');
if isempty(map)
    map = colormap('gray');
    colormap(map);
    nbcol = size(map,1);
end

% Perform SWT decomposition
[ca,chd,cvd,cdd] = swt2(X,levels,filter);

% Visualize the decomposition.

for k = 1:3
    % Images coding for level k.
    cod_ca  = wcodemat(ca(:,:,k),nbcol);
    cod_chd = wcodemat(chd(:,:,k),nbcol);
    cod_cvd = wcodemat(cvd(:,:,k),nbcol);
    cod_cdd = wcodemat(cdd(:,:,k),nbcol);
    decl = [cod_ca,cod_chd;cod_cvd,cod_cdd];

    % Visualize the coefficients of the decomposition
    % at level k.
    subplot(2,2,k+1)
    image(decl)

    title(['SWT dec.: approx. ', ...
   'and det. coefs (lev. ',num2str(k),')']);
    colormap(map)
end
% Editing some graphical properties,
% the following figure is generated.

end