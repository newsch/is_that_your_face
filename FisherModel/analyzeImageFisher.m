function [Distances, ClassIndices] = analyzeImageFisher(face,ClassedWeights,FisherFaces)
% ANALYZEIMAGEFISHER  Analyze an image with a Fisherface model.
    sFace = stackim(face);
    nFace = sFace - mean(sFace);  % subtract average of face from face
    weights = FisherFaces'*sFace;  % express image in Fisherspace
    unsorteddistances = sqrt(sum((ClassedWeights - weights).^2, 1));  % compute Euclidean distances
    [Distances,ClassIndices] = sort(unsorteddistances);  % value and index of minimum values
end
