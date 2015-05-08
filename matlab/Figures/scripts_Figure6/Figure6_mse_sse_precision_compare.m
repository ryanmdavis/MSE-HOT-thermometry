%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


function precision=Figure6_mse_sse_precision_compare(varargin)
if nargin==1
    display_on=varargin{1};
else
    display_on=1;
end
%% RMD272
reconstruct('RMD272',[22 29]);
R_RMD272=Rois();
R_RMD272.loadRois('C:\Users\Ryan2\Documents\Warren Lab Work\Analysis\HOT signal vs TE\marrow ROIs\RMD272 marrow.roi');
masks272=boolean(squeeze(R_RMD272.getMasks));
ave_272_std=squeeze(std(RMD272_Sc29_HOT.t_ave_uncorr,0,1));
sli_272_std=squeeze(std(RMD272_Sc22_HOT_MSE_ZQSQ3.t,0,1));
precision_272=[ave_272_std(masks272),sli_272_std(masks272)];
mean_272=mean(precision_272);
median_272=median(precision_272);

%% RMD273
reconstruct('RMD273',[20 26]);
R_RMD273=Rois();
R_RMD273.loadRois('C:\Users\Ryan2\Documents\Warren Lab Work\Analysis\HOT signal vs TE\marrow ROIs\RMD273 marrow.roi');
masks273=boolean(squeeze(R_RMD273.getMasks));
ave_273_std=squeeze(std(RMD273_Sc20_HOT.t_ave_uncorr,0,1));
sli_273_std=squeeze(std(RMD273_Sc26_HOT.t(:,1,1,:,:),0,1));
precision_273=[ave_273_std(masks273),sli_273_std(masks273)];
mean_273=mean(precision_273);
median_273=median(precision_273);

%% RMD275
reconstruct('RMD275',[30 31]);
R_RMD275=Rois();
R_RMD275.loadRois('C:\Users\Ryan2\Documents\Warren Lab Work\Analysis\HOT signal vs TE\marrow ROIs\RMD275 marrow.roi');
masks275=boolean(squeeze(R_RMD275.getMasks));
ave_275_std=squeeze(std(RMD275_Sc30_HOT.t_ave_uncorr,0,1)); %for this one I average over different vaues of t1
sli_275_std=squeeze(std(RMD275_Sc31_HOT.t(:,1,1,:,:),0,1));
precision_275=[ave_275_std(masks275),sli_275_std(masks275)];
mean_275=mean(precision_275);
median_275=median(precision_275);

%% summary of all datasets
fs=18;
precision=[precision_272' precision_273' precision_275']';

if display_on
    f_h=figure,hist(precision,0:0.1:3.1);
    xlim([0 3]);
    xlabel('temperature precision (\circC)','FontSize',fs);
    ylabel('number of voxels','FontSize',fs);
    set(gca,'FontSize',fs-3);
    axis square
    legend('MSE','SSE');
end