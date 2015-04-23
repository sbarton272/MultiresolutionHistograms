# MultiresolutionHistograms
18-790 Project Spring 2015

# Algorithm

## Constants
- Number of resolution levels
- Branching variance

## Training
1. Per class, per image perform entropy based pruning
2. Sepecifically, decend in resolution (spatial), apply histograms (greyscale) to parent and children. Compare max entropy of children to parent energies. If children have too much of an uneven energy spread then select parent. If the spread the spread is uneven this implies the parent is as good as the children.
2. Continue entering resolutions until at minimum level or entropy convergence (like a breadth first search with children as frontier).
3. Now construct resolution structures per class
4. Structure is determined by voting on images in class. Most common resolution levels are picked.
5. Train an svm per class using the class structure. The svm input feature is the concatinated histograms applied at each level. The svm utilizes each training image.

## Testing
1. Break down the test image useing the entropy algorithm.
2. Naive bayes to determine probability in each class based soley on structure
3. Using cutoff (found through cross validation), slected likely classes
4. Perform structred breakdown per likely class and extract each feature vector
5. Apply feature vectors to corrisponding svm
6. Select most likely class from svm output

# Dataset

- Images from 18720
- 8 classes: airport, auditorium, bamboo\_forest, campus, desert, football\_field, kitchen, sky
- Test images 20 images each class
- Train images airport (57), auditorium (326), bamboo\_forest (124), campus (160), desert (295), football\_field (38), kitchen (335), sky (148)


# Ideas

- Wavelet instead of spatial decomposition

# TODO

- (Important) Paper
- (Done) Run once
- (Done) Baseline with Gaussian
- Play around with Bayes - check accuracy of just this component (Gavi)
- Structure differences (how are different are they)(Gavi)
- RGB histograms (Spencer)
- Entropy functions for pruning (experimentation) (Spencer)
- Number of levels
- Reduced size histograms (bins)
