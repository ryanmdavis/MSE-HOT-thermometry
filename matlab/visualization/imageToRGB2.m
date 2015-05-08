%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


function im_mod = imageToRGB2(im,varargin)
if nargin>=2
    c_map=varargin{1};
else
    c_map=jet;
end
if nargin>=3
    intensity_range(1)=varargin{2}(1);
    intensity_range(2)=varargin{2}(2);
else
    intensity_range(1)=min(min(im));
    intensity_range(2)=max(max(im));
end

im(im > max(intensity_range)) = max(intensity_range);
im(im < min(intensity_range)) = min(intensity_range);

j_mod = c_map;

intensity_range_total = max(intensity_range) - min(intensity_range);

im_lin = reshape(im,1,size(im,1)*size(im,2));
im_lin_pos = im_lin - min(intensity_range);
im_lin_scale = im_lin_pos/intensity_range_total;
im_lin_jet = j_mod(round(im_lin_scale*(size(j_mod,1)-1)+1),:);
im_mod = reshape(im_lin_jet,size(im,1),size(im,2),3);