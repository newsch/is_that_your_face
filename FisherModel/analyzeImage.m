function [Distances, ClassIndices] = analyzeImage(face,ClassedWeights,FisherFaces)
% ANALYZEIMAGE  Analyze an image with a Fisherface model.
    sFace = stackim(face);
    nFace = sFace - mean(sFace);  % subtract average of face from face
    weights = model.fisherfaces'*nFace;  % express image in Fisherspace
    unsorteddistances = sqrt(sum((ClassedWeights - weights).^2, 1));  % compute Euclidean distances
    [Distances,ClassIndices] = sort(unsorteddistances);  % value and index of minimum values
end
