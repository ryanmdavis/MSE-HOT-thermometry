%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


function roi_sizes = getRoiSizes(obj,varargin)
if size(varargin,2) == 0
    roi_num_list = 1:obj.getLength;
elseif size(varargin,2) == 1
    roi_num_list = varargin{1};
else
    error('Inappropriate number of input arguments');
end

roi_count = 1; %in case the user does not input a list of consecutive ints
for roi_num = roi_num_list
    roi_sizes(roi_count) = obj.getSpecRoi(roi_num).getNumPix;
    roi_count = roi_count + 1;
end