function [classedWeights,Classes,FisherFaces] = createFisherModel(faces, EigenFaces, classes, limit)
% CREATEFISHERMODEL  Create a model for Fisherface recognition.
    if nargin < 3
        [h,w,d] = size(faces);
        limit = d;  % set limit to max if none given
    end
    sFaces = stackim(faces);  % faces stacked in column vectors
    nFaces = (sFaces - mean(sFaces,1))./sqrt(length(sFaces(:,1)));  % normalize faces
    fCovarriance = nFaces'*nFaces;  % covarriance matrix of faces
    [V,D] = eig(fCovarriance);
    AllEigenFaces = nFaces*fliplr(V);  % flip Eigenfaces so strongest is first
    EigenFaces = AllEigenFaces(:,1:limit);  % limit eigenfaces (and weights indirectly)
    allWeights = EigenFaces'*nFaces;

    %% Arrange classes in preparation for Sb and Sw calculations
    [Classes,ia,ic] = unique(classes);  % get unique names and their indices
    numClasses = length(Classes);  % number of unique classes
    numImages = length(classes);  % total number of images is the same as the total number of unfiltered class entries
    numDims = length(allWeights(:,1));  % number of dimensions in Eigenspace we're working in (length of one image in Eigenspace)
    
    %% Find W_opt using Sb and Sw
    % Sb of faces in Eigenspace
    AverageClassFaces = zeros(numDims,numClasses);
    for i = 1:length(Classes)  % create average face for each class (person)
        AverageClassFaces(:,i) = mean(allWeights(:,ic==i),2);
    end

    TotalAverageFace = mean(allWeights,2);  % create average face of all faces, not accounting for difference in class sizes

    Sb = zeros(numDims);
    for i = 1:numClasses
        numImagesInClass = sum(ic==i);
        Sb = Sb + (numImagesInClass*(AverageClassFaces(:,i)-TotalAverageFace)*(AverageClassFaces(:,i)-TotalAverageFace).');
    end

    % Sw of faces in Eigenspace
    Sw = zeros(numDims);
    for i = 1:numClasses  % calculate nested sums
        innerSum = (allWeights(:,ic==i) - AverageClassFaces(:,i)) * (allWeights(:,ic==i) - AverageClassFaces(:,i))';
        Sw = Sw + innerSum;
    end
    [Wopt,D] = eig(Sb,Sw);
    %% calculate average weights of classes
    FisherFaces = EigenFaces*Wopt;
    nFisherFaces = (FisherFaces - mean(FisherFaces,1)); %./sqrt(length(sFaces(:,1)));  % normalize faces
    fisherWeights = nFisherFaces'*stackim(faces);
    classedWeights = zeros(length(fisherWeights(:,1)),length(Classes));
    for i = 1:length(Classes)
        weightsToAverage = fisherWeights(:,ic == i);  % get all weights under the same class (person)
        classedWeights(:,i) = sum(weightsToAverage,2)./length(weightsToAverage(1,:));  % average weights to single vector
    end

end
