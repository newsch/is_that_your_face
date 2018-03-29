function [namedWeights,Names,EigenFaces] = createEigenModel(faces, names, limit)
% CREATEEIGENMODEL  Create a model for Eigenface recognition.
    if nargin < 3
        [h,w,d] = size(faces);
        limit = d;  % set limit to max if none given
    end
    sFaces = stackim(faces);  % faces stacked in column vectors
    nFaces = (sFaces - mean(sFaces,1))./sqrt(length(sFaces(:,1)));  % normalize faces
    fCovarriance = nFaces'*nFaces;  % covarriance matrix of faces
    [V,D] = eig(fCovarriance);
    AllEigenFaces = sFaces*fliplr(V);  % flip Eigenfaces so strongest is first
    EigenFaces = AllEigenFaces(:,1:limit);  % limit eigenfaces (and weights indirectly)
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
