function [map] = normalize_map(map)
% By Yiren Lu at University of Pennsylvania
% 04/04/2016
% ESE 650 Project 5

map = double(map);
minval = min(min(map));
maxval = max(max(map));
% normalize to 0.01 to 1
map(:) = (map(:) - minval + eps)/(maxval-minval+eps) * 0.99+0.01;

end