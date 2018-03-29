clear all

file = 'classdata_full.mat'
load(file);

%% preprocess different classdata format
newNames = string(zeros(1,length(y.name)));
for i = 1:length(y.name)  % fix names for some datapoints in 'classdata_full.mat'
    groups = regexp(y.name(i),'(?<name>\w*)_\d\d\.\w*','names');  % get name w/ RegEx capturing group
    newNames(i) = groups{1}.name;  % select name of first find
end
y.name = newNames;

% %% create and use model
% [W,N,E] = initialize(grayfaces,y.name,132);
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
test.images = grayfaces(:,:,testI);
test.names = y.name(testI);
train.images = grayfaces(:,:,trainI);
train.names = y.name(trainI);
limit = 50  % limit of eigenfaces/weights to use
% limit = length(train.names)

% create model with train data
disp('Building model.'); tic
[model.weights,model.names,model.eigenfaces] = initialize(train.images,train.names,limit);
modelTime = toc;
disp('Finished building model with ' + string(length(train.names)) + ' images.')
disp('Total time was ' + string(modelTime) + ' seconds.')

% test model with test data
disp('Running tests.'); tic
results = string(zeros(length(model.names),length(test.names)));
distances = zeros(length(model.names),length(test.names));
testTimes = zeros(length(test.names),1);
for i = 1:length(test.names)
    avgStart = tic;
    [D,Ni] = analyzeImage(test.images(:,:,i),model.weights,model.eigenfaces);
    testTimes(i) = toc(avgStart);
    results(:,i) = string(model.names(Ni));  % save all name guesses
    distances(:,i) = D;  % save all distances
end
avgtime = mean(testTimes);
testTime = toc;
disp('Finished running ' + string(length(test.names)) + ' tests.')
disp('Total time was ' + string(testTime) + ' seconds.')
disp('Average time was ' + string(avgtime) + ' seconds.')

% analyze results
correct = results(1,:) == test.names;  % check if first guess was correct
disp('Results: ' + string(sum(correct)) + ' out of ' + string(length(results(1,:))) + ' correct guesses.')
incorrect.names = results(:,~correct);
incorrect.distances = distances(:,~correct);
incorrect.expected = test.names(~correct);


function [namedWeights,Names,EigenFaces] = initialize(faces, names, limit)
    if nargin < 3
        [h,w,d] = size(faces);  % set limit to max if none given
        limit = d;
    end
    sFaces = stackImage(faces);  % faces stacked in column vectors
    nFaces = (sFaces - mean(sFaces,1))./sqrt(length(sFaces(:,1)));  % normalize faces
    fCovarriance = nFaces'*nFaces;  % covarriance matrix of faces
    [V,D] = eig(fCovarriance);
    AllEigenFaces = sFaces*fliplr(V);  % flip Eigenfaces so strongest is first
    EigenFaces = AllEigenFaces(:,1:limit);  % limit eigenfaces (and weights indirectly)
%     imagesc(unstackImage(eigenFaces(:,end)))
    allWeights = linsolve(EigenFaces,nFaces);  % generate weights for training set
    limitedWeights = allWeights(end-limit+1:end,:);
    %% organize by name and calculate average weights
    [Names,ia,ic] = unique(names);  % get unique names and their indices
    namedWeights = zeros(length(limitedWeights(:,1)),length(Names));
    for i = 1:length(Names)
        weightsToAverage = limitedWeights(:,ic == i);  % get all weights under the same name
        namedWeights(:,i) = sum(weightsToAverage,2)./length(weightsToAverage(1,:));  % average weights to single vector
    end
    namedWeights = namedWeights(1:limit,:);
end

function [Distance, NameIndices] = analyzeImage(face,NamedWeights,EigenFaces)
    %% process image
    sFace = stackImage(face);
    nFace = sFace - mean(sFace);
    weight = linsolve(EigenFaces,nFace);  % project image into face space
    distances = sqrt(sum((NamedWeights - weight).^2, 1));  % compute Euclidean distances
    [Distance,NameIndices] = sort(distances);  % value and index of minimum values
end

function A = stackImage(im)
    [l,w,n] = size(im);
    A = reshape(im,l*w,n);
end

function A = unstackImage(im)
    [l,w,n] = size(im);
    A = reshape(im,sqrt(l),sqrt(l),w);
end