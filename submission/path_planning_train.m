% By Yiren Lu at University of Pennsylvania
% April 3 2016
% ESE 650 Project 5 Path Planning with Imitation Learning
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all
addpath ./mex


imagepath = 'aerial_color_d8.jpg';
load('trainset_car3');
load('trainset_walk3');


% Please execute ONE of the following data preparation procedure and
% train
% 1) or 2)
%% 1)driving training data preparation
load('feat_eng_maps5');
feature_maps = feat_eng_maps5;
w = w_eng5;
cost_map = compute_cost_map(feature_maps, w);
imagesc(cost_map);
trainset = trainset_walk3;

%% 2)walk training data preparation
load('walk_feat_maps');
feature_maps = walk_feat_maps;
w = w_walk;
cost_map = compute_cost_map(feature_maps, w);
imagesc(cost_map);
trainset = trainset_walk3;


%% Imitation learning, Using gradient descient to learn the weights
lr = 1e-4;
total_step = 500;

lastJ = 0

colormap default
for i = 1:total_step
    i
    tic
    grad = zeros(size(w,1),numel(trainset));
    totalJ = 0;
    imagesc(cost_map); hold on;
    for j = 1:numel(trainset)
        points = trainset{j};
        start = [points(1,2), points(1,1)];
        goal = [points(end,2) points(end,1)];

        ctg = dijkstra_matrix(cost_map,ceil(goal(1)),ceil(goal(2)));
        [ip1, jp1] = dijkstra_path(ctg, cost_map, start(1), start(2));

        plot(points(1:end,1), points(1:end,2),'r-','LineWidth',2);
        plot(jp1(1:end), ip1(1:end), 'm-','LineWidth',2);
        drawnow;
        
        [grad(:,j) J] = compute_gradient(w,feature_maps,cost_map,[ip1,jp1],[points(:,2) points(:,1)]);
        totalJ = totalJ + J;
    end
    hold off;
    drawnow;
    avg_grad = mean(grad,2);
    w = w - lr*avg_grad;
    cost_map = compute_cost_map(feature_maps,w);
	[w lr*avg_grad]
    [totalJ,lastJ]
    lastJ = totalJ;
    toc
end




%% Toy example:Imitation learning, Using gradient descient to learn the weights
lr = 1e-2;
total_step = 500;
map1 = [1,1,1;
        1,0,1;
        1,0,1;
        1,0,1;];
map2 = [0,0,0;
        0,1,0;
        0,1,0;
        0,1,0];
map3 = [1,0,0;
        0,1,0;
        0,0,1;
        1,0,0];
map4 = [0,1,0;
        1,0,1;
        0,1,0;
        1,0,1];
feature_maps = {-map1,-map2,map3,map4};
w = ones(numel(feature_maps), 1)/numel(feature_maps);


cost_map = compute_cost_map(feature_maps, w);
% trainset = trainset_walk;
trainset = {[3,4;3,3;3,2;2,1;1,2;1,3;1,4]}

lastJ = 0

for i = 1:total_step
    i
    tic
    grad = zeros(size(w,1),numel(trainset));
    totalJ = 0;
    imagesc(cost_map); hold on;
    for j = 1:numel(trainset)
%     for j = 3
        points = trainset{j};
        start = [points(1,2), points(1,1)];
        goal = [points(end,2) points(end,1)];


        ctg = dijkstra_matrix(cost_map,ceil(goal(1)),ceil(goal(2)));
        [ip1, jp1] = dijkstra_path(ctg, cost_map, start(1), start(2));

        plot(points(1:end,1), points(1:end,2),'r-','LineWidth',2);
        plot(jp1(1:end), ip1(1:end), 'y-','LineWidth',2);
        drawnow;
        
        [grad(:,j) J] = compute_gradient(w,feature_maps,cost_map,[ip1,jp1],[points(:,2) points(:,1)]);
        totalJ = totalJ + J;
    end
    hold off;
    drawnow;
    avg_grad = mean(grad,2);
    w = w - lr*avg_grad;
    cost_map = compute_cost_map(feature_maps,w);
	[w lr*avg_grad]
    [totalJ,lastJ]
%     if(totalJ == lastJ)
%         lr = lr*0.1;
%     end
    lastJ = totalJ;
    toc
end



