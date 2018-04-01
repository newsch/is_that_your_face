function [Distance, NameIndices] = analyzeImageEigen(face,NamedWeights,EigenFaces)
% ANALYZEIMAGEEIGEN  Analyze an image with an Eigenface model.
    sFace = stackim(face);
    nFace = sFace - mean(sFace);
    weight = linsolve(EigenFaces,nFace);  % project image into face space
    distances = sqrt(sum((NamedWeights - weight).^2, 1));  % compute Euclidean distances
    [Distance,NameIndices] = sort(distances);  % value and index of minimum values
end
