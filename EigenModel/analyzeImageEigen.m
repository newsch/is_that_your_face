function [Distance, NameIndices] = analyzeImageEigen(face,NamedWeights,EigenFaces)
% ANALYZEIMAGEEIGEN  Analyze an image with an Eigenface model.
    sFace = stackim(face);
    mFace = sFace - mean(sFace);
    weight = EigenFaces'*mFace;  % project image into face space
    distances = sqrt(sum((NamedWeights - weight).^2, 1));  % compute Euclidean distances
    [Distance,NameIndices] = sort(distances);  % value and index of minimum values
end
