function [ g ] = gaussian( x, sigma )
    g = exp(-x.^2/(2*sigma^2)) / (sigma*sqrt(2*pi));
    g = g / sum(g);
end



