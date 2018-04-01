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
    AllEigenFaces = sFaces*fliplr(V);  % flip Eigenfaces so strongest is first
    EigenFaces = AllEigenFaces(:,1:limit);  % limit eigenfaces (and weights indirectly)
%     allWeights = linsolve(EigenFaces,nFaces);  % generate weights for training set
%     allWeights = EigenFaces\nFaces;
    allWeights = EigenFaces'*nFaces;
    limitedWeights = allWeights(end-limit+1:end,:);
    
    %% Find W_opt using Sb and Sw
    % Sb of faces in Eigenspace
    AverageClassFaces = zeros(132,66);
    for i = 1:66  % create average face for each class (person)
        AverageClassFaces(:,i) = (allWeights(:,2*i)+allWeights(:,2*i-1))/2 ;
    end

    TotalAverageFace = zeros(132,1);
    for i = 1:132  % create average face of all faces
        TotalAverageFace = TotalAverageFace + allWeights(:,i);
    end
    TotalAverageFace = TotalAverageFace./132;

    Sb = zeros(132,132);
    for i = 1:66
        Sb = Sb + (2*(AverageClassFaces(:,i)-TotalAverageFace)*(AverageClassFaces(:,i)-TotalAverageFace).') ;
    end

    % Sw of faces in Eigenspace
    Sw = zeros(132,132);
    for i = 1:66
        InsideWithin2 = zeros(132,132);
        for k = 1:2
            InsideWithin1 = (allWeights(:,2*i-2+k) - AverageClassFaces(:,i)) * (allWeights(:,2*i-2+k) - AverageClassFaces(:,i)).' ;
            InsideWithin2 = InsideWithin2 + InsideWithin1;
        end
        Sw = Sw + InsideWithin2;
    end
    [Wopt,D] = eig(Sb,Sw);
    %% organize by name and calculate average weights
    [Classes,ia,ic] = unique(names);  % get unique names and their indices
    model.fisherfaces = EigenFaces*Wopt;
    fisherWeights = model.fisherfaces'*reshape(faces,h^2,w,1);
    classedWeights = zeros(length(fisherWeights(:,1)),length(Classes));
    for i = 1:length(Classes)
        weightsToAverage = fisherWeights(:,ic == i);  % get all weights under the same class (person)
        classedWeights(:,i) = sum(weightsToAverage,2)./length(weightsToAverage(1,:));  % average weights to single vector
    end
    
    model.weights = classedWeights;
    model.names = Classes;
    model.eigenfaces = EigenFaces;
end
