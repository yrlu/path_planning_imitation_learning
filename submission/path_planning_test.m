% By Yiren Lu at University of Pennsylvania
% April 2 2016
% ESE 650 Project 5 Path Planning with Imitation Learning
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;

addpath utils
addpath mex

imagepath = 'aerial_color_d8.jpg';
I8 = imread(imagepath);

%% test driving paths
clc;
clear all;
  
addpath utils
addpath mex

imagepath = 'aerial_color_d8.jpg';
I8 = imread(imagepath);

load('feat_eng_maps5','feat_eng_maps5','w_eng5','cost_map')
feature_maps = feat_eng_maps5;
w = w_eng5;
cost_map = compute_cost_map(feature_maps, w);
% imagesc(cost_map); hold on;
imshow(I8);hold on;
while 1
    points = [];
points = ginput;
start = [points(1,2), points(1,1)];
goal = [points(end,2) points(end,1)];

ctg = dijkstra_matrix(cost_map,ceil(goal(1)),ceil(goal(2)));
[ip1, jp1] = dijkstra_path(ctg, cost_map, ceil(start(1)), ceil(start(2)));

% plot(points(1:end,1), points(1:end,2),'r-','LineWidth',2);
plot(jp1(1:end), ip1(1:end), 'm-','LineWidth',2);
drawnow;
end

%% test walk paths
clc;
clear all;

addpath utils
addpath mex

imagepath = 'aerial_color_d8.jpg';
I8 = imread(imagepath);

load('walk_feat_maps','walk_feat_maps','w_walk','cost_map');

feature_maps = walk_feat_maps;
w = w_walk;
cost_map = compute_cost_map(feature_maps, w);
% imagesc(cost_map); hold on;
imshow(I8);hold on;
while 1
    points = [];
points = ginput;
start = [points(1,2), points(1,1)];
goal = [points(end,2) points(end,1)];

ctg = dijkstra_matrix(cost_map,ceil(goal(1)),ceil(goal(2)));
[ip1, jp1] = dijkstra_path(ctg, cost_map, ceil(start(1)), ceil(start(2)));

% plot(points(1:end,1), points(1:end,2),'r-','LineWidth',2);
plot(jp1(1:end), ip1(1:end), 'm-','LineWidth',2);
drawnow;
end