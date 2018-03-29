function A = stackim(im)
% STACKIM  Stack 3D matrices of images
% Turn a 3-dimensional matrix of square images into a 2-dimensional matrix
% of column images.
    [l,w,n] = size(im);
    A = reshape(im,l*w,n);
end

