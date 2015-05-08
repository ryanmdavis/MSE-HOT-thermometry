%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


setHOTReconOption('num_echoes_avg',16,'recon_size',128);
Figure6_mse_sse_precision_compare(1);
f_hist=gcf;
Figure6_mse_precision_vs_num_echoes_avg;


set(f_echo_num,'Position',[585 366 560 420]);
set(f_hist,'Position',[9 367 560 420]);