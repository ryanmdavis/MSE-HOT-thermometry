%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


function yvals = getYVals(obj)

yvals = zeros(1,obj.getLength());    
    for roi_num = 1:obj.getLength()
        centroid = obj.getSpecRoi(roi_num).getCentroid();
        yvals(roi_num) = centroid(2);
    end