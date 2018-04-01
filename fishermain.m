% fishermain.m  run testFisherModel

clear all
import FisherModel.*
% import EigenModel.createEigenModel

load classdata.mat

%% analyzing accuracy
% setup data and values
testI = y.picnum ~= 0;
trainI = ones(size(y.picnum));
testData.images = grayfaces(:,:,testI);
testData.classes = y.name(testI);
trainData.images = grayfaces(:,:,trainI);
trainData.classes = y.name(trainI);
limit = 132  % limit of eigenfaces/weights to use
% limit = length(train.names)
[EigenWeights, EigenNames, EigenFaces] = createEigenModel(trainData.images,trainData.classes,132);
[results,distances,times] = testFisherModel(trainData,testData,limit,EigenFaces);
% analyze results
correct = results(1,:) == testData.classes;  % check if first guess was correct
disp('Results: ' + string(sum(correct)) + ' out of ' + string(length(results(1,:))) + ' correct guesses.')
incorrect.classes = results(:,~correct);
incorrect.distances = distances(:,~correct);
incorrect.expected = testData.classes(~correct);