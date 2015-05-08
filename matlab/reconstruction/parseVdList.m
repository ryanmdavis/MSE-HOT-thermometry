%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


function vd = parseVdList(vd_list_string)

space_i = strfind(vd_list_string,' ');
vd = zeros(1,size(space_i,2));
if space_i(1) ~= 1 space_i = [1 space_i]; end
for ii = 2:size(space_i,2)
    vd(ii-1) = str2num(vd_list_string(space_i(ii-1):space_i(ii)));
end

if vd(end)==0 vd=vd(1:(end-1)); end