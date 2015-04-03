function structure = computeStructure(X, depth, wname, entropyType, param, debug)

%% Consts
LEVEL_WIDTH = 4; % four branches at each level

%% Defaults

if isempty(wname)
    wname = 'haar';
end

if isempty(entropyType)
    entropyType = 'shannon';
end

if isempty(debug)
    debug = false;
end

%% Optimal wavelet decomp
tree = wpdec2(X, depth, wname, entropyType, param);

%% Calculate structure vector
ind = allnodes(tree.tree_struct);
nNodes = (1 - LEVEL_WIDTH^(depth+1)) / (1 - LEVEL_WIDTH);
structure = zeros(nNodes, 1);
structure(ind) = 1;

%% Debug plot
if debug
   figure; plot(tree.tree_struct);
end

end
