function d = d_gaussian(x, sigma)
    d = -x.* gaussian(x,sigma) / sigma^2;
    d = d / sum(-x .* d);
end

