function [kmeans_maps, Iseg] = get_kmeans_maps(I, feat_map, K)
% By Yiren Lu at University of Pennsylvania
% 04/04/2016
% ESE 650 Project 5
tic
I = I.*repmat(uint8(feat_map),[1,1,3]);
kmeans_maps = zeros(size(feat_map,1),size(feat_map,2),K);
Ihsv = rgb2hsv(I);
Imed = Ihsv;

for i = 10
Imed(:,:,1)=medfilt2(Imed(:,:,1));
Imed(:,:,2)=medfilt2(Imed(:,:,2));
Imed(:,:,3)=medfilt2(Imed(:,:,3));
end

Ipixels = reshape(Imed,[size(I,1)*size(I,2),3]);

idx = kmeans(double(Ipixels),K);



for i = 1:K
    tmp = zeros(size(Ipixels,1),1);
    tmp(idx==i)= 1; 
    kmeans_maps(:,:,i) = reshape(tmp, [size(I,1),size(I,2)]);
    Ipixels(idx==i,:) = i;
end

Iseg = reshape(Ipixels(:,1:3), [size(I,1),size(I,2),3]);
Iseg = mean(Iseg,3);
toc