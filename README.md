# Is _That_ Your Face?

Facial recognition with Linear Algebra.

Created by Evan New-Schmidt and Luis Zuñiga for the second module of the Quantitative Engineering Analysis course at Olin College of Engineering.

## Contents

Not included with this purchase: the data used to create and test these models.

### Project Structure

```
.
│   FisherFacesApproach.mlx - working livescript for Fisherfaces
│   README.md - this file
│   stackim.m - helper function for converting image data to columns
│   unstackim.m - helper function for reversing stackim.m
│
├───/DataCleanup - scripts for cleaning testing data
│
├───/EigenModel - functions for creating, testing, and using Eigenface models
│       analyzeImageEigen.m
│       createEigenModel.m
│       testEigenModel.m
│
├───/figures - images outputted by the program
│
├───/FisherModel - functions for creating, testing, and using Fisherface models
│       analyzeImageFisher.m
│       createFisherModel.m
│       testFisherModel.m
│
└───/Scripts - scripts to use and analyze the models
        finaleigen.m - tests an Eigenface model with the final train/test data
        finalfisher.m - tests a Fisherface model with the final train/test data
        runeigen.m - general testing of Eigenface models
        runfisher.m - general testing of Fisherface models
        sweepLimitTest.m - analysis of speed/accuracy with varying #s of dimensions
        testUnknownFaces.m - analysis of the model with unknown faces
```
