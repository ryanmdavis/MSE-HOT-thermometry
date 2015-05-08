%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


function xvals = getXVals(obj)

xvals = zeros(1,obj.getLength());    
    for roi_num = 1:obj.getLength()
        centroid = obj.getSpecRoi(roi_num).getCentroid();
        xvals(roi_num) = centroid(1);
    end