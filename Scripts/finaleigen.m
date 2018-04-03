% runeigen.m  run the eigen model with the final train/test datasets
% Authors: Luis Zuñiga, Evan Lloyd New-Schmidt

clear all
import EigenModel.*

file = 'classdata_full_fixed.mat'
load(file);

%% analyzing accuracy
% setup data and values
% testI = y.picnum == 0;
% trainI = y.picnum ~= 0;
% testData.images = grayfaces(:,:,testI);
% testData.names = y.name(testI);
% trainData.images = grayfaces(:,:,trainI);
% trainData.names = y.name(trainI);
trainData.names = y.name;
trainData.images = grayfaces;

load classdata_demo_fixed.mat
testData.names = y.name;
testData.images = grayfaces;

limit = 50  % limit of eigenfaces/weights to use
% limit = length(train.names)

% check for discrepancies
disp('Differences between names of train and test data:')
setdiff(trainData.names,testData.names)
setdiff(testData.names,trainData.names)

[results,distances,times] = testEigenModel(trainData,testData,limit);
% analyze results
correct = results(1,:) == testData.names;  % check if first guess was correct
disp('Results: ' + string(sum(correct)) + ' out of ' + string(length(results(1,:))) + ' correct guesses.')
incorrect.names = results(:,~correct);
incorrect.distances = distances(:,~correct);
incorrect.expected = testData.names(~correct);
