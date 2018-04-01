% testUnknownFaces.m  Find the calculated distances of unknown faces.

clear all
import EigenModel.*

file = 'classdata_full_fixed.mat'
load(file);

% split data into train/test sets
% get people with exactly 8 images

testI = y.picnum == 0;
trainI = y.picnum ~= 0;
testData.images = grayfaces(:,:,testI);
testData.names = y.name(testI);
trainData.images = grayfaces(:,:,trainI);
trainData.names = y.name(trainI);

% datasets for unknown images
AllImages = y.picnum <= 1;  % first two images of everyone
utestI = 1:111;
utrainI = 112:222;
utestData.images = grayfaces(:,:,utestI);
utestData.names = y.name(utestI);
utrainData.images = grayfaces(:,:,utrainI);
utrainData.names = y.name(utrainI);

limit = 40;

% create and run models
[results,distances,times] = testEigenModel(trainData,testData,limit);
[uresults,udistances,utimes] = testEigenModel(utrainData,utestData,limit);

% analyze results
correct = results(1,:) == testData.names;  % check if first guess was correct
ucorrect = uresults(1,:) == utestData.names;
accuracy = sum(correct)/length(testData.names)*100
uaccuracy = sum(ucorrect)/length(utestData.names)*100

knownDistances = distances(1,:);
unknownDistances = udistances(1,:);

figure; hold on
histogram(knownDistances,15)
histogram(unknownDistances,15)
axis([0.2 1 0 20])
legend('known distances','unknown distances')
title('Calculated Distances of Known and Unknown Faces')

disp('Known Distances (mean,min,max,median):')
mean(knownDistances)
min(knownDistances)
max(knownDistances)
median(knownDistances)

disp('Unknown Distances (mean,min,max,median):')
mean(unknownDistances)
min(unknownDistances)
max(unknownDistances)
median(unknownDistances)