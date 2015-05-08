%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


function obj_return = minus(obj_pre,obj_post)
masks = zeros(size(obj_pre.getSpecRoi(1).getMask,1),size(obj_pre.getSpecRoi(1).getMask,2),obj_pre.getLength);
for pre_num = 1:obj_pre.getLength
    this_mask = obj_pre.getSpecRoi(pre_num).getMask;
    for post_num = 1:obj_post.getLength
        anded = boolean(this_mask) & boolean(obj_post.getSpecRoi(post_num).getMask);
        this_mask(anded) = 0;
    end
    masks(:,:,pre_num) = reshape(this_mask,1,size(obj_pre.getSpecRoi(1).getMask,1),size(obj_pre.getSpecRoi(1).getMask,2));
end
obj_return = Rois(masks,'input_type','masks');