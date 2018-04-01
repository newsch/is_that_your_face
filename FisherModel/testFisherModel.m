function [results,distances,times] = testFisherModel(train, test, limit)
% TESTFISHERMODEL  Create and test an Fisherface model with train and test data.
% results: best estimates of classification
% distances: calculated distances for each estimate
% times: measured times for total time building the model, total time
% testing the model, and the average time testing each image
    % create model with train data
    disp('Building model with ' + string(length(train.classes)) + ' images.'); tic
    [model.weights,model.classes,model.fisherfaces] = createFisherModel(train.images,train.classes,limit);
    modelTime = toc;
    disp('Finished building model.')
    disp('Total time was ' + string(modelTime) + ' seconds.')
    
    % test model with test data
    disp('Testing model with ' + string(length(test.classes)) + ' images.'); tic
    results = string(zeros(length(model.classes),length(test.classes)));
    distances = zeros(length(model.classes),length(test.classes));
    testTimes = zeros(length(test.classes),1);
    for i = 1:length(test.classes)
        avgStart = tic;
        [D,Ci] = analyzeImage(test.classes(:,:,i),model.weights,model.fisherfaces);
        testTimes(i) = toc(avgStart);
        results(:,i) = string(model.classes(Ci));  % save all class guesses
        distances(:,i) = D;  % save all distances
    end
    avgtime = mean(testTimes);
    testTime = toc;
    disp('Finished testing model.')
    disp('Total time was ' + string(testTime) + ' seconds.')
    disp('Average time was ' + string(avgtime) + ' seconds.')
    times = [modelTime testTime avgtime];
end

