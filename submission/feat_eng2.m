% feature_engineering

%% 04/04/2016

clc
clear all
addpath ./mex
addpath ./utils

imagepath = 'aerial_color.jpg';
I = imread(imagepath);

Ihsv = rgb2hsv(I);
Iycbcr = rgb2ycbcr(I);
Ilab = rgb2lab(I);



%%%%%%Thresholding%%%%%%%%%%%%

%%%%%%LAB COLOR SPACE %%%%%%%%%
%% binary map of all the grass & bushes, recommmended
imshow(I);
se = strel('ball',20,20);
% greens = round(normalize_map(double(Ilab(:,:,2)<-10)));
greens = round(normalize_map(imdilate(imerode(double(Ilab(:,:,2)<-10),se),se)));
imagesc(I.*repmat(uint8(greens),[1,1,3]));
greens8 = greens(1:8:end,1:8:end);

%% roof top (part, and part of the sidewalk), not recommended 
se = strel('ball',20,20);
rooftop = round(normalize_map(imdilate(imerode(double(normalize_map(Ilab(:,:,1))>0.5),se),se)));
imagesc(I.*repmat(uint8(rooftop),[1,1,3]));
rooftop8 = rooftop(1:8:end,1:8:end);
%% shadows, recommended
se = strel('ball',10,10);
ILAB1 = Ilab(:,:,1);
for i=1:5
ILAB1 = medfilt2(ILAB1);
ILAB1 = imgaussfilt(ILAB1);
end
shadows = round(normalize_map(imdilate(imerode(double(normalize_map(ILAB1)<0.05),se),se)));
% shadows = normalize_map(ILAB1)<0.05;
% [shadowsout ~]=getLargestCc(shadows,[],1000);
imagesc(shadows);
shadows8 = shadows(1:8:end,1:8:end);

%% white bounder, not recommended, use white rooftops
ILAB1 = Ilab(:,:,1);
white = normalize_map(ILAB1)==1;
imagesc(white);
white8 = white(1:8:end,1:8:end);

%% white rooftops, not accessable, recommended

se = strel('ball',20,20);
white_rooftops = round(normalize_map(imdilate(imerode(double(normalize_map(Ilab(:,:,1))>0.9),se),se)));
imagesc(I.*repmat(uint8(white_rooftops),[1,1,3]));
white_rooftops8 = white_rooftops(1:8:end,1:8:end);

%% greens and red sports court, including some red roottops, not recommended
greens_red = normalize_map(Ilab(:,:,3))>0.65;
imagesc(I.*repmat(uint8(round(greens_red)),[1 1 3]));
greens_red8=greens_red(1:8:end,1:8:end);

%% rooftops,part, including shadows, recommended

se = strel('ball',20,20);
ILAB3 = Ilab(:,:,3);
for i =1:5
ILAB3 = imgaussfilt(ILAB3);
end
rooftops_shadows = round(normalize_map(imdilate(imerode(double(normalize_map(ILAB3)<0.5),se),se)));
imagesc(I.*repmat(uint8(rooftops_shadows),[1,1,3]));
rooftops_shadows8 = rooftops_shadows(1:8:end,1:8:end);

%%%%%%YCBCR COLOR SPACE %%%%%%%%%
%% rooftops, including shadows, strongly recommended
se = strel('ball',30,30);
Iycbcr2 = Iycbcr(:,:,2);
Iycbcr2 = normalize_map(Iycbcr2)>0.511;
tic
Iycbcr2 = imdilate(imerode(double(Iycbcr2),se),se);
Iycbcr2 = imerode(imdilate(double(Iycbcr2),se),se);
toc
rooftops_shadows_ybr = round(normalize_map(Iycbcr2));
imagesc(rooftops_shadows_ybr);
% imagesc(I.*repmat(uint8(rooftops_shadows_ybr),[1,1,3]));
rooftops_shadows_ybr8 = rooftops_shadows_ybr(1:8:end,1:8:end);

%% walks, strongly recommended for walk
% on the contrary, building + roads
greens_sidewalk = normalize_map(Iycbcr(:,:,2))<0.45;
imagesc(I.*repmat(uint8(round(greens_sidewalk)),[1 1 3]));
greens_sidewalk8 = greens_sidewalk(1:8:end,1:8:end);
% imagesc(greens_sidewalk);
%% greens, recommended
greens_ycbcr = normalize_map(Iycbcr(:,:,3))<0.35;
imagesc(I.*repmat(uint8(round(greens_ycbcr)),[1 1 3]));
greens_ycbcr8 = greens_ycbcr(1:8:end,1:8:end);
%%%%%%HSV COLOR SPACE %%%%%%%%%
%% rooftop, recommended
se = strel('ball',20,20);
rooftop_hsv = round(normalize_map(imerode(imdilate(imdilate(imerode(double(normalize_map(Ihsv(:,:,1))>0.4),se),se),se),se)));
imagesc(rooftop_hsv);
% imagesc(I.*repmat(uint8(rooftop_hsv),[1,1,3]));
rooftop_hsv8 = rooftop_hsv(1:8:end,1:8:end);

%% another set of rooftops, recommended
se = strel('ball',20,20);
rooftop_hsv_2 = round(normalize_map((double(normalize_map(Ihsv(:,:,1))<0.2))));
imagesc(rooftop_hsv_2);
% imagesc(I.*repmat(uint8(rooftop_hsv),[1,1,3]));
rooftop_hsv_2_8 = rooftop_hsv_2(1:8:end,1:8:end);

%% greens hsv 2, recommended
% greens and red sports court, including some red roottops
se = strel('ball',20,20);
greens_hsv = round(normalize_map(imdilate(imdilate(imerode(imerode(double(normalize_map(Ihsv(:,:,2))>0.25),se),se),se),se)));
imagesc(greens_hsv);
greens_hsv8 = greens_hsv(1:8:end,1:8:end);
% imagesc(I.*repmat(uint8(round(~greens_hsv)),[1 1 3]));

%% shadows, recommended
shadow_hsv = round(normalize_map((double(normalize_map(Ihsv(:,:,3))<0.1))));
% imagesc(I.*repmat(uint8(round(shadow_hsv)),[1 1 3]));
imagesc(shadow_hsv);
% 
shadow_hsv8 = shadow_hsv(1:8:end,1:8:end);



%%%%%%%%%edges%%%%%%%%%%%%
%% 
I8 = imread('aerial_color_d8.jpg');

Ihsv8 = rgb2hsv(I8);
Iycbcr8 = rgb2ycbcr(I8);
Ilab8 = rgb2lab(I8);

%%
I10 = imread('aerial_color_d10.jpg');

Ihsv10 = rgb2hsv(I10);
Iycbcr10 = rgb2ycbcr(I10);
Ilab10 = rgb2lab(I10);






%% extracted buildings

% white_rooftops;
% rooftops_shadows;
% rooftops_shadows_ybr;
% rooftop_hsv;
% rooftop_hsv_2;

rooftop_union = white_rooftops | rooftops_shadows | rooftops_shadows_ybr | rooftop_hsv | rooftop_hsv_2;
imagesc(rooftop_union);

%% 
buildings = ( white_rooftops | rooftops_shadows | rooftops_shadows_ybr | rooftop_hsv | rooftop_hsv_2 );




%% extracted greens 


% greens;greens_sidewalk;greens_ycbcr;greens_hsv;
greens_union = greens|greens_sidewalk|greens_ycbcr|greens_hsv;
imagesc(greens_union);

%% extracted shadows
% shadows;shadow_hsv;
shadows_union = shadows|shadow_hsv;
imagesc(shadows_union);

%% greens | rooftops

imagesc(rooftop_union | greens_union);

%% greens | rooftops ~shadows %% basic feature maps for driving
drive_basic = (rooftop_union | greens_union) & ~shadows_union;
imagesc(~drive_basic); 


%% basic feature maps for walking
% imagesc(~greens_sidewalk); % | white_rooftops);
walk_basic = ~((greens_sidewalk) & (~white_rooftops)) & ~shadows_union;
% imagesc(walk_basic);
imagesc(I.*repmat(uint8(~walk_basic),[1,1,3]));

% walk_basic_maps = {~greens_sidewalk8, white_rooftops8, ~shadows_union(1:8:end,1:8:end),edge_c(1:8:end,1:8:end)};
walk_basic_maps = {walk_basic(1:8:end,1:8:end), double(I8(:,:,1))/255,double(I8(:,:,2))/255,double(I8(:,:,3))/255,edge_c(1:8:end,1:8:end)};
w_walk_basic = ones(numel(walk_basic_maps), 1);
cost_map = compute_cost_map(walk_basic_maps, w_walk_basic);
imagesc(cost_map);
% save('walk_basic_maps','walk_basic_maps','w_walk_basic');
%%
walk_feat_maps = {greens8,greens_sidewalk8,shadows8,rooftops_shadows_ybr8,edge_c(1:8:end,1:8:end),edge_p(1:8:end,1:8:end),edge_s(1:8:end,1:8:end)};
w_walk = [0.2;-1;-0.8;0.1;0.1;0.1;0.1];
feature_maps = walk_feat_maps;
w = w_walk;
cost_map = compute_cost_map(walk_feat_maps, w_walk);
imagesc(cost_map);
% walk_basic8 = walk_basic(1:8:end,1:8:end);

% se = strel('ball',20,20);
% walk_basic_after = round(normalize_map(imerode(imdilate(double(walk_basic),se),se)));
% imagesc(walk_basic_after);
% imagesc(I.*repmat(uint8(walk_basic_after),[1,1,3]));
%% LAB


edge_c10 = edge(Ilab10(:,:,1), 'Canny');
edge_p10 = edge(Ilab10(:,:,1), 'Prewitt',10);
edge_s10 = edge(Ilab10(:,:,1), 'Sobel',12);


edge_c = imresize(edge_c10,[size(I,1) size(I,2)]);
edge_p = imresize(edge_p10,[size(I,1) size(I,2)]);
edge_s = imresize(edge_s10,[size(I,1) size(I,2)]);


imagesc(edge_s);
% subplot(3,1,1); imagesc(edge_c);
% subplot(3,1,2); imagesc(edge_p);
% subplot(3,1,3); imagesc(edge_s);


%% refine building maps
% building_map;
% rooftop_union = white_rooftops | rooftops_shadows | rooftops_shadows_ybr | rooftop_hsv | rooftop_hsv_2;
% imagesc(rooftop_union);
% tmp = building_map | rooftop_union(1:8:end,1:8:end);
% tmp = building_map;
tmp = (bwareaopen(rooftop_union(1:8:end,1:8:end), 40) | bwareaopen(building_map, 40) | greens_union(1:8:end,1:8:end)) & ~shadows_union(1:8:end,1:8:end) | edge_c(1:8:end,1:8:end);
% tmp = 
for i = 1:1
    tmp = medfilt2(tmp);
end
imagesc(tmp);

newdrive_map = tmp & ~pb_r_map(1:2:end,1:2:end);

%% GMM 
I =  imread('aerial_color_d4.jpg');
Ihsv = rgb2hsv(I);
Iycbcr = rgb2ycbcr(I);
Imed = Ihsv;
Imed = imgaussfilt(Imed, 1);
Ire = reshape(Imed,[size(I,1)*size(I,2),3]);

%% road
BW_road = zeros(size(I,1),size(I,2));
%%
% for i = 1:20
for i = 1:2
BW_road = BW_road | roipoly(I);
end
pixels_road = Ire(find(BW_road(:)),:);
[mu_r, sigma_r] = gmm_train(double(pixels_road),5);
pb_r = gmm_predict(mu_r, sigma_r, double(Ire));
pb_r_map = normalize_map(reshape(pb_r,[size(I,1) size(I,2)]));
pb_r_map = bwareaopen(medfilt2(pb_r_map)>0.05,500);
imagesc(pb_r_map);
% imagesc(I.*repmat(uint8(pb_r_map>0.04),[1,1,3]));
% imagesc(pb_r_map>0.5);
% end

%% greens
BW_greens = zeros(size(I,1),size(I,2));
for i = 1:20
    BW_greens = BW_greens | roipoly(I);
end
pixels_greens = Ire(find(BW_greens(:)),:);
[mu_g, sigma_g] = gmm_train(double(pixels_greens),5);
pb_g = gmm_predict(mu_g, sigma_g, double(Ire));
%% buildings
BW_buildings = zeros(size(I,1),size(I,2));
for i = 1:20
    BW_buildings = BW_buildings | roipoly(I);
end
pixels_buildings = Ire(find(BW_buildings(:)),:);
[mu_b, sigma_b] = gmm_train(double(pixels_buildings),5);
pb_b = gmm_predict(mu_b, sigma_b, double(Ire));

%%

BW_others = ~BW_buildings & ~BW_road & ~BW_greens;
pixels_others = Ire(find(BW_others(:)),:);
[mu_o, sigma_o] = gmm_train(double(pixels_others),5);
pb_o = gmm_predict(mu_o, sigma_o, double(Ire));

%%

pb_r = gmm_predict(mu_r, sigma_r, double(Ire));
pb_g = gmm_predict(mu_g, sigma_g, double(Ire));
pb_b = gmm_predict(mu_b, sigma_b, double(Ire));
pb_o = gmm_predict(mu_o, sigma_o, double(Ire));



%% summary new features
tmp = (bwareaopen(rooftop_union(1:8:end,1:8:end), 40) | bwareaopen(building_map, 40) | greens_union(1:8:end,1:8:end)) & ~shadows_union(1:8:end,1:8:end) | edge_c(1:8:end,1:8:end);
for i = 1:1
    tmp = medfilt2(tmp);
end
imagesc(tmp);
newdrive_map = tmp & ~pb_r_map(1:2:end,1:2:end);
% building_blocks = medfilt2(imdilate(double(bwareaopen(building_map, 40)),se));

% feat_eng_maps = {rooftop_union(1:8:end,1:8:end), building_map, greens_union(1:8:end,1:8:end), ~shadows_union(1:8:end,1:8:end),edge_c(1:8:end,1:8:end),edge_p(1:8:end,1:8:end),~pb_r_map(1:2:end,1:2:end)};
feat_eng_maps = {medfilt2(bwareaopen(rooftop_union(1:8:end,1:8:end),40)), medfilt2(bwareaopen(building_map,40)), medfilt2(greens_union(1:8:end,1:8:end)), medfilt2(~shadows_union(1:8:end,1:8:end)),edge_c(1:8:end,1:8:end),edge_p(1:8:end,1:8:end),medfilt2(~pb_r_map(1:2:end,1:2:end))};
w_eng = [0.1;0.1;0.1;0.01;0.1;0.1;0.1]*0.001;
cst = compute_cost_map(feat_eng_maps,w_eng);
imagesc(cst);

%% 
% feat_eng_maps2 = {newdrive_map}, edge_c(1:8:end,1:8:end),edge_p(1:8:end,1:8:end),edge_s(1:8:end,1:8:end)}
feat_eng_maps2 = {newdrive_map, edge_c(1:8:end,1:8:end),edge_p(1:8:end,1:8:end),edge_s(1:8:end,1:8:end)}
w_eng2 = [1;0.3;0.3;0.3];
cst = compute_cost_map(feat_eng_maps2,w_eng2);
imagesc(log(cst));


%% 
% roof features:
% white_rooftops | rooftops_shadows | rooftops_shadows_ybr | rooftop_hsv |
% rooftop_hsv_2 | building_map(8)
% green features:
% greens|greens_sidewalk|greens_ycbcr|greens_hsv;
% Shadows:
% shadows|shadow_hsv;
% edges:
% edge_c(1:8:end,1:8:end),edge_p(1:8:end,1:8:end),edge_s(1:8:end,1:8:end)
% sidewalks:(kmeans segmentation of greens_sidewalk)
% greens_sidewalk_kmeans(:,:,2:6);

% edge_c(1:8:end,1:8:end),edge_p(1:8:end,1:8:end),edge_s(1:8:end,1:8:end),...
feat_eng_maps3 = {white_rooftops8,rooftops_shadows8,rooftops_shadows_ybr8,rooftop_hsv8,...
    rooftop_hsv_2_8,building_map,...
    greens8,greens_sidewalk8,greens_ycbcr8,greens_hsv8,...
    ~shadows8,~shadow_hsv8,... 
    greens_sidewalk_kmeans(:,:,2),greens_sidewalk_kmeans(:,:,3),greens_sidewalk_kmeans(:,:,4),greens_sidewalk_kmeans(:,:,5),greens_sidewalk_kmeans(:,:,6)};
w_eng3 = ones(numel(feat_eng_maps3), 1)/numel(feat_eng_maps3);
cst = compute_cost_map(feat_eng_maps3, w_eng3);
imagesc(cst);


%%
feat_eng_maps4 = {white_rooftops8,rooftops_shadows_ybr8,rooftop_hsv8,...
    rooftop_hsv_2_8,building_map,...
    greens8,...
    ~shadows8,... 
    greens_sidewalk_kmeans(:,:,3),greens_sidewalk_kmeans(:,:,6)};
w_eng4 = ones(numel(feat_eng_maps4), 1)/numel(feat_eng_maps4);
cst = compute_cost_map(feat_eng_maps4, w_eng4);
imagesc(cst);

%%
feat_eng_maps5 = {newdrive_map,edge_c(1:8:end,1:8:end),edge_p(1:8:end,1:8:end),edge_s(1:8:end,1:8:end)};
% w_eng5 = ones(numel(feat_eng_maps5), 1)/numel(feat_eng_maps5);
w_eng5=[1;0.1;0.1;0.1]*2;
w = w_eng5;
feature_maps = feat_eng_maps5;
cost_map = compute_cost_map(feat_eng_maps5, w_eng5);
imagesc(cost_map);
% save('feat_eng_maps5','feat_eng_maps5','w_eng5');

%%
se = strel('ball',100,100);
roofxxx = rooftops_shadows_ybr8;
% for i = 1:4
roofxxx = normalize_map(imdilate(roofxxx,se));
% end
imagesc(roofxxx);

%%

feat_eng_maps6 = {newdrive_map,pb_r_map(1:2:end,1:2:end),edge_c(1:8:end,1:8:end),edge_p(1:8:end,1:8:end),reshape(pb_g,[size(I8,1), size(I8,2)]),reshape(pb_r,[size(I8,1), size(I8,2)]),rooftop_union(1:8:end,1:8:end)};
w_eng6 = ones(numel(feat_eng_maps6), 1)/numel(feat_eng_maps6);
save('feat_eng_maps6','feat_eng_maps6','w_eng6');





%%
building_map2 = medfilt2(bwareaopen(building_map,10));
imagesc(building_map2);
%%
rooftop_summary = (bwareaopen(rooftop_union(1:8:end,1:8:end), 40) | bwareaopen(building_map, 40) | greens_union(1:8:end,1:8:end)) & ~shadows_union(1:8:end,1:8:end) ;
for i = 1:1
    rooftop_summary = medfilt2(rooftop_summary);
end
imagesc(rooftop_summary);
% newdrive_map = tmp & ~pb_r_map(1:2:end,1:2:end);



%% walk


