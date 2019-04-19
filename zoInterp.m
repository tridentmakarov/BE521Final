function x_out = zoInterp(x,numInterp)
% Interpolates the feature for each data point, zero-order


x_new = repmat(x, numInterp, 1);
x_out = reshape(x_new, 1, []);

end

