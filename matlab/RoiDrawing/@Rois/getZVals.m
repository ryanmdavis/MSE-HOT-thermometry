%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


function zvals = getRoiAvgs(obj,img)

zvals = zeros(1,obj.getLength());    
    for roi_num = 1:obj.getLength()
        mask = obj.getSpecRoi(roi_num).getMask();
        masked = mask .* img;
        total = sum(sum(masked));
        zvals(roi_num) = total/obj.getSpecRoi(roi_num).getNumPix();
    end