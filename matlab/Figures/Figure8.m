setHOTReconOption('recon_size',256);
%%exp 1
reconstruct('RMD310',4:5);
R4=Rois();
R4.loadRois(strcat(hotPath('roi'),'\Fig8_Sc4.roi'));
avg_sc4=R4.getRoiAvgs(squeeze(RMD310_Sc4_HOT.nu(1,1,1,:,:)));
std_sc4=R4.getRoiStDevs(squeeze(RMD310_Sc4_HOT.nu(1,1,1,:,:)));

%%exp 2
reconstruct('RMD310',[13 15]);
R15=Rois();
R15.loadRois(strcat(hotPath('roi'),'\Fig8_Sc15.roi'));
avg_sc15=R15.getRoiAvgs(squeeze(RMD310_Sc15_HOT.nu(1,1,1,:,:)));
std_sc15=R15.getRoiStDevs(squeeze(RMD310_Sc15_HOT.nu(1,1,1,:,:)));

%%exp 3
reconstruct('RMD310',[19 21]);
R21=Rois();
R21.loadRois(strcat(hotPath('roi'),'\Fig8_Sc21.roi'));
avg_sc21=R21.getRoiAvgs(squeeze(RMD310_Sc21_HOT.nu(1,1,1,:,:)));
std_sc21=R21.getRoiStDevs(squeeze(RMD310_Sc21_HOT.nu(1,1,1,:,:)));

%%exp 4
reconstruct('RMD310',50:51);
rare_sc50=imresize(squeeze(abs(RMD310_Sc51_rare(2,:,:))),2);
R50=Rois();
R50.loadRois(strcat(hotPath('roi'),'\Fig8_Sc50.roi'));
avg_sc50=R50.getRoiAvgs(squeeze(RMD310_Sc50_HOT.nu(1,1,1,:,:)));
std_sc50=R50.getRoiStDevs(squeeze(RMD310_Sc50_HOT.nu(1,1,1,:,:)));

%%exp5
reconstruct('RMD310',[54 56]);
R56=Rois();
R56.loadRois(strcat(hotPath('roi'),'\Fig8_Sc56.roi'));
avg_sc56=R56.getRoiAvgs(squeeze(RMD310_Sc56_HOT.nu(1,1,1,:,:)));
std_sc56=R56.getRoiStDevs(squeeze(RMD310_Sc56_HOT.nu(1,1,1,:,:)));

avgs=[avg_sc4';avg_sc15';avg_sc21';avg_sc50';avg_sc56'];


%% display figure
background_mask=~(abs(rare_sc50)>1.2e4);
nu_range=[1060 1110];
nu_map_rgb=intensity2RGB(squeeze(RMD310_Sc50_HOT.nu(1,1,1,:,:)),jet,nu_range);
nu_map_rgb=rgbBackgroundToBlack(nu_map_rgb,background_mask);

rare_rgb=intensity2RGB(abs(rare_sc50),gray);

figure
subplot(1,2,1);
imagesc(rare_rgb);
axis square off
title('RARE image');
subplot(1,2,2);
imagesc(nu_map_rgb);
axis square off
title('iZQC frequency');
niceFigure(gcf);

figure,imagesc(ones(64),nu_range);
colorbar
niceFigure(gcf);
title('iZQC frequency colorbar');