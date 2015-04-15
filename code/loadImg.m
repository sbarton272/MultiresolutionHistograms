function I = loadImg(path, root)

filepath = [root, path];
I = imread(filepath);
end