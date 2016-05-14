function [cost_map] = compute_cost_map(feature_maps, w)
% By Yiren Lu at University of Pennsylvania
% 04/02/2016
% ESE 650 Project 5 

% compute the cost map according to feature maps and weights
% Inputs:
%   feature_maps:       a struct that contains all the feature maps
%   w:                  1*m weights

cost_map = zeros(size(feature_maps{1},1),size(feature_maps{1},2));
for i = 1:numel(feature_maps)
    cost_map = cost_map + w(i) * double(feature_maps{i});
end
cost_map(:) = exp(cost_map(:)) ;

% if(mean(mean(cost_map)) < 0.0001)
%     cost_map = cost_map*10;
% end
end
