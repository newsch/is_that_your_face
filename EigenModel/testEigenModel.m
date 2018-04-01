function [results,distances,times] = testEigenModel(train, test, limit)
% TESTEIGENMODEL  Create and test an Eigenface model with train and test data.
    % create model with train data
    disp('Building model with ' + string(length(train.names)) + ' images.'); tic
    [model.weights,model.names,model.eigenfaces] = createEigenModel(train.images,train.names,limit);
    modelTime = toc;
    disp('Finished building model.')
    disp('Total time was ' + string(modelTime) + ' seconds.')

    % test model with test data
    disp('Testing model with ' + string(length(test.names)) + ' images.'); tic
    results = string(zeros(length(model.names),length(test.names)));
    distances = zeros(length(model.names),length(test.names));
    testTimes = zeros(length(test.names),1);
    for i = 1:length(test.names)
        avgStart = tic;
        [D,Ni] = analyzeImageEigen(test.images(:,:,i),model.weights,model.eigenfaces);
        testTimes(i) = toc(avgStart);
        results(:,i) = string(model.names(Ni));  % save all name guesses
        distances(:,i) = D;  % save all distances
    end
    avgtime = mean(testTimes);
    testTime = toc;
    disp('Finished testing model.')
    disp('Total time was ' + string(testTime) + ' seconds.')
    disp('Average time was ' + string(avgtime) + ' seconds.')
    times = [modelTime testTime avgtime];
end

