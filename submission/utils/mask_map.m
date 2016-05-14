function [masked_map] = mask_map(I, mask)
% By Yiren Lu at University of Pennsylvania
% 04/04/2016
% ESE 650 Project 5
% I is the rgb(or other colorspace) image
% mask is a binary mask
masked_map = I.*repmat(uint8(round(mask)),[1 1 3]);
end