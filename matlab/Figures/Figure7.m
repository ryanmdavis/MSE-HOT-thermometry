% load images
setHOTReconOption('decomposition','off');
setHOTReconOption('recon_size',32);
reconstruct('RMD280',14);
reconstruct('RMD281',5); 
time_per_image=2.23;%min
time_axis_hot=linspace(0+time_per_image/2,66-time_per_image/2,30);
pt=round([79 60]/4);

% load Luxtron data
load(strcat(hotPath('luxtron'),'\RMD280 luxtron data'));
time_axis_lux=(s.timestamps_sec-s.timestamps_sec(1))/60;
temperature_measurements_lux=s.temperature_values(:,4);
lux_baseline=mean(temperature_measurements_lux(1:40));

temperature_measurements_hot_uncorr=squeeze(RMD280_Sc14_HOT.t_ave_uncorr(:,1,pt(1),pt(2)));
temperature_measurements_hot_uncorr_basesub=temperature_measurements_hot_uncorr-mean(temperature_measurements_hot_uncorr(1:5))+lux_baseline;

% load calibration curve
load(hotPath('calibration'),'nu_of_T')

f_h=figure;subplot(1,2,1); set(gcf,'position',[183 378 800 320]);
imagesc(squeeze(abs(RMD281_Sc5_rare(2,:,:))));
boxOnImage(pt*4,'r',4);
axis image off
colormap gray
title('T_2-weighted image of marrow sample');
xlim([17 105]);
ylim([30 118]);


subplot(1,2,2);
scatter(time_axis_hot,temperature_measurements_hot_uncorr,'bo')
xlim([0 60]);
hold on
scatter(time_axis_hot,temperature_measurements_hot_uncorr_basesub,'rx','SizeData',80)
[haxis,hline1,hline2]=plotyy(time_axis_lux',temperature_measurements_lux,time_axis_lux',temperature_measurements_lux);
plot(time_axis_lux',temperature_measurements_lux,'k');
set(haxis(2),'YTickLabel',nu_of_T(str2num(get(haxis(1),'YTickLabel')),7)); %#ok<ST2NM>
axis(haxis,'square');
legend('MSE-HOT uncorr.','MSE-HOT corr.','Fiberoptic');
xlabel('time (min)');
ylabel(haxis(1),'temperature (\circC)','color','k');
ylabel(haxis(2),'iZQC frequency (Hz)','color','k');
set(haxis,'YColor','k');
set(hline2,'visible','off');

niceFigure(f_h);
set(f_h,'Name','RMD280')
set(f_h,'Position',[183 271 876 427]);
% print(gcf,'C:\Users\Ryan2\Documents\My manuscripts and conference abstracts\Multi-echo HOT encoding\figures\Luxtron vs MSE-HOT\luxtron','-dtiff','-r300');