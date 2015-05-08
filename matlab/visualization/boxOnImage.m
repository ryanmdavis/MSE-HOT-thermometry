%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


function boxOnImage(pt,c,varargin)

%set size of box in voxels/pixels
if nargin==3
    s=varargin{1};
else
    s=1;
end

line([pt(2)-s pt(2)-s pt(2)+s pt(2)+s pt(2)-s],[pt(1)-s pt(1)+s pt(1)+s pt(1)-s pt(1)-s],'color',c,'LineWidth',2);