function A = unstackim(im)
% UNSTACKIM  Unstack 2D matrices of images
% Turn a 2-dimensional matrix of column images into a 3-dimensional matrix
% of square images.
    [l,w,n] = size(im);
    A = reshape(im,sqrt(l),sqrt(l),w);
end