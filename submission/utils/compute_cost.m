function [cost] = compute_cost(cost_map, path)
% By Yiren Lu at University of Pennsylvania
% 04/02/2016
% ESE 650 Project 5 
% Input:
%   cost_map:       the cost map
%   path:           n*2 coordinates along the path

inds = sub2ind(size(cost_map), path(:,1), path(:,2));
cost = sum(cost_map(inds));
