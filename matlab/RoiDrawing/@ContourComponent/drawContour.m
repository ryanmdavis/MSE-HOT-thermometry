%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


function drawContour(obj,varargin)
invar = struct('axes_h',gca,'width',1,'color','b','style','-','f_h',gcf,'shift',[0 0],'scale',1);
argin = varargin;
invar = generateArgin(invar,argin);
axes(invar.axes_h)
figure(invar.f_h);
for segment_number=1:size(obj.component_start_position,2)-1;
    row_points=(obj.row_points(1+obj.component_start_position(segment_number):obj.component_start_position(segment_number+1))*invar.scale);
    col_points=(obj.col_points(1+obj.component_start_position(segment_number):obj.component_start_position(segment_number+1))*invar.scale);
    line(col_points+invar.shift(1),row_points+invar.shift(2),'linewidth',invar.width,'color',invar.color,'linestyle',invar.style);
end