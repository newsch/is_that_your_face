% main.m  Facial Recognition with EigenFaces
% Authors: Luis Zuñiga, Evan Lloyd New-Schmidt

clear all
import EigenModel.*

file = 'classdata_full.mat'
load(file);

% %% create and use model
% [W,N,E] = createEigenModel(grayfaces,y.name,132);
% % size(unstackImage(stackImage(grayfaces)))
% testImage = grayfaces(:,:,67);
% imagesc(testImage)
% colormap gray
% [D,Ni] = analyzeImage(testImage,W,E);
% D(1:4)
% N(Ni(1:4))

%% analyzing accuracy
% setup data and values
testI = y.picnum == 0;
trainI = y.picnum ~= 0;
testData.images = grayfaces(:,:,testI);
testData.names = y.name(testI);
trainData.images = grayfaces(:,:,trainI);
trainData.names = y.name(trainI);
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
