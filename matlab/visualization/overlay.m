%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


function overlay_rgb=overlay(background_img,background_colormap,background_range,foreground_img,foreground_colormap,foreground_range,foreground_mask)

background_rgb=intensity2RGB(background_img,background_colormap,background_range);
foreground_rgb=intensity2RGB(foreground_img,foreground_colormap,foreground_range);
overlay_rgb=superpose2RGB(foreground_rgb,background_rgb,foreground_mask);