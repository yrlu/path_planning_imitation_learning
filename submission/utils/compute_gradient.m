function [grad, J] = compute_gradient(w, feature_maps, cost_map, path_predicted, path_train)
% By Yiren Lu at University of Pennsylvania
% 04/02/2016
% ESE 650 Project 5 
% Compute the gradient based on feature_maps, cost_map, training and
% predicted path
% Inputs:
%   w:      weights
%   feature_map:        struct feature_maps 
%   cost_map:           cost_map
%   path_predicted:     predicted path 
%   path_train:         train set path


% compute new weights
% J = sum(C(x,y)*) - sum(C(x,y))
% C(x,y) = exp{w'*feat_maps}
% xy^* is the training path, xy is the predicted path
% gradient_k = sum(F_k(xy^*)^* *exp{sum(w_k*F_k(xy^*))} - sum(F_k(xy)^* *exp{sum(w_k*F_k(xy))}



J = compute_cost(cost_map, path_train) - compute_cost(cost_map, path_predicted);
inds_pred = sub2ind(size(cost_map), path_predicted(:,1), path_predicted(:,2));
inds_train = sub2ind(size(cost_map), path_train(:,1), path_train(:,2));
grad = zeros(size(w,1),1);
for k = 1:numel(w)
    feat_map = feature_maps{k};
    grad(k) = feat_map(inds_train)'*cost_map(inds_train) - feat_map(inds_pred)'*cost_map(inds_pred);
end

end