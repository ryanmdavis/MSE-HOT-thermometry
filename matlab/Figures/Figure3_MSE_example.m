%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


fs=18;
%%load images
setHOTReconOption('decomposition','off','fermi_E',6,'fermi_T',1,'recon_size',128,'num_echoes_avg',16);
reconstruct('RMD273',[5 20 26]);
[mse2_zq_windows,mse2_sq_windows] = zqsqCoherenceOrder(16);
max_intensity_zq=max(max(max(squeeze(abs(RMD273_Sc20_HOT.im(1,1,mse2_zq_windows,:,:))))));
max_intensity_sq=max(max(max(squeeze(abs(RMD273_Sc20_HOT.im(1,1,mse2_sq_windows,:,:))))));

% ZQ images
f_mse2_zq=figure;
set(f_mse2_zq,'Position',[75  593 1005 200]);
set(gcf,'Name','ZQSQ2 - iZQC');
colormap gray
for mse_num=1:16
    subplot(2,8,mse_num);
    imagesc(squeeze(abs(RMD273_Sc20_HOT.im(1,1,mse2_zq_windows(mse_num),:,:))),[0 max_intensity_zq]);
    axis square off
%     title(strcat('TE=',num2str(mse2_te(mse_num)),'ms'),'FontSize',fs);
end
% subplot(3,8,17);%this kludge makes the images look better
axis off

f_mse2_sq=figure;
set(f_mse2_sq,'Position',[75  393 1005 200]);
set(gcf,'Name','ZQSQ2 - SQC');
colormap gray
for mse_num=1:16
    subplot(2,8,mse_num);
    imagesc(squeeze(abs(RMD273_Sc20_HOT.im(1,1,mse2_sq_windows(mse_num),:,:))),[0 max_intensity_sq]);
    axis square off
%     title(strcat('TE=',num2str(mse2_te(mse_num)),'ms'),'FontSize',fs);
end

% subplot(3,8,17);%this kludge makes the images look better
axis off

%% generate precision overlays - echo averaging

% rgb rare
rare=squeeze(abs(RMD273_Sc5_rare(2,:,:)));
rare=rare/max(max(rare));
rare_rgb=imageToRGB2(rare,gray,[0 0.8]); 

%generate precision map
avg_precision = squeeze(std(RMD273_Sc20_HOT.t_ave_uncorr,0,1));
avg_precision_rgb=imageToRGB2(avg_precision,jet,[0 1.5]);

R_marrow=Rois();
% R_marrow.loadRois('C:\Users\Ryan2\Documents\My manuscripts and conference abstracts\Multi-echo HOT encoding\figures\ROIs\RMD273 marrow.roi');
R_marrow.loadRois(strcat(hotPath('roi'),'\RMD273 marrow.roi'));
mask=R_marrow.getMasks();

%superpose the precision map and rare image
avg_overlay=superpose2RGB(avg_precision_rgb,rare_rgb,mask);

%% generate temperature overlay
temp=squeeze(RMD273_Sc20_HOT.t_ave_uncorr(1,1,:,:));
temp_overlay=overlay(rare,gray,[0 1],temp,hot,[38 48],mask);

%% generate precision overlays - SLI
precision_range=[0 1.5];
%generate precision map
sli_precision = squeeze(std(RMD273_Sc26_HOT.t(:,1,1,:,:),0,1));
sli_precision_rgb=imageToRGB2(sli_precision,jet,precision_range);

%superpose the precision map and rare image
sli_overlay=superpose2RGB(sli_precision_rgb,rare_rgb,mask);

%assemble precision data into a single variable
precision=[sli_precision(boolean(mask)),avg_precision(boolean(mask))];

%display the data
f_overlay=figure;
set(f_overlay,'Position',[76 119 1005 200]);
subplot(1,3,1), imagesc(sli_overlay,precision_range); axis image off; colorbar; title('MSE precision','FontSize',18);
subplot(1,3,2), imagesc(avg_overlay,precision_range); axis image off; colorbar; title('SSE precision','FontSize',18);
f_hist=figure, hist(precision,0:0.1:2.1); legend('SSE','MSE'); axis square
fs_hist=15;
xlabel('temperature precision (\circC)','FontSize',fs_hist);
ylabel('number of voxels','FontSize',fs_hist);
set(gca,'FontSize',fs_hist-3);
xlim([0 2]);
set(f_hist,'Position',[731 86 384 241]);

figure(f_mse2_zq);