% sweepLimitTest.m  Build multiple models sweeping across limits.

clear all
import EigenModel.*

file = 'classdata_full_fixed.mat'
load(file);

% split data into train/test sets
testI = y.picnum == 0;
trainI = y.picnum ~= 0;
testData.images = grayfaces(:,:,testI);
testData.names = y.name(testI);
trainData.images = grayfaces(:,:,trainI);
trainData.names = y.name(trainI);

sweep.limits = uint8(linspace(1,length(trainData.names),10));
sweep.accuracy = zeros(size(sweep.limits));
sweep.times = zeros(4,length(sweep.accuracy));
sweep.outputs = string(zeros(size(sweep.limits)));

disp('Beginning ' + string(length(sweep.times)) + ' sweeps of model limit.')
for i = 1:length(sweep.limits)
    tic;
    [T,results,distances,times] = evalc('testEigenModel(trainData,testData,sweep.limits(i));');
    totalTime = toc;
    % analyze results
    correct = results(1,:) == testData.names;  % check if first guess was correct
    sweep.accuracy(i) = sum(correct)/length(testData.names)*100;
    sweep.times(:,i) = [totalTime; times'];
    sweep.outputs(i) = T;
    disp('Finished ' + string(i) + ' out of ' + string(length(sweep.limits)) + ' sweeps.')
    disp('Total time was ' + string(totalTime) + ' seconds.')
end
disp('Finished running sweeps.')
figure
plot(sweep.limits,sweep.accuracy)
title('accuracy vs limit')
xlabel('Numer of Eigenfaces used in model')
ylabel('Accuracy (%)')
figure
plot(sweep.limits,sweep.times(4,:))
title('average analysis time vs limit')
xlabel('Number of Eigenfaces used in model')
ylabel('Average analysis time per test image (seconds)')