% finalfisher.m  run the fisher model with the final train/test datasets
% Authors: Luis Zuñiga, Evan Lloyd New-Schmidt

clear all
import FisherModel.*
% import EigenModel.createEigenModel

file = 'classdata_fisher_fixed.mat'
load(file);

%% analyzing accuracy
% setup data and values
% testI = y.picnum == 3;
% trainI = true(size(y.picnum));'
% testI = y.picnum == 0;
% trainI = y.picnum ~= 0;
% testData.images = grayfaces(:,:,testI);
% testData.classes = y.name(testI);
% trainData.images = grayfaces(:,:,trainI);
% trainData.classes = y.name(trainI);

trainData.images = grayfaces;
trainData.classes = y.name;

load classdata_demo_fixed.mat
testData.images = grayfaces;
testData.classes = y.name;

eigenlimit = 132  % limit of eigenfaces/weights to use
fisherlimit = 50
% limit = length(train.names)

% check for discrepancies
disp('Differences between names of train and test data:')
setdiff(trainData.classes,testData.classes)
setdiff(testData.classes,trainData.classes)

% build and test model
[EigenWeights, EigenNames, EigenFaces] = createEigenModel(trainData.images,trainData.classes,eigenlimit);
[results,distances,times] = testFisherModel(trainData,testData,EigenFaces,fisherlimit);
% analyze results
correct = results(1,:) == testData.classes;  % check if first guess was correct
disp('Results: ' + string(sum(correct)) + ' out of ' + string(length(results(1,:))) + ' correct guesses.')
incorrect.classes = results(:,~correct);
incorrect.distances = distances(:,~correct);
incorrect.expected = testData.classes(~correct);