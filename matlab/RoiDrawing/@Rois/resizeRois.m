%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


function new_obj = resizeRois(obj,factor)
    masks = obj.getMasks;
    new_masks = zeros(size(masks,1),size(masks,2) * factor,size(masks,3) * factor);
    for mask_num = 1:size(masks,1)
        new_masks(mask_num,:,:) = reshape(imresize(reshape(masks(mask_num,:,:),size(masks,2),size(masks,3)),factor,'nearest'),1,size(new_masks,2),size(new_masks,3));
    end
    new_obj = Rois(new_masks,'input_type','masks');