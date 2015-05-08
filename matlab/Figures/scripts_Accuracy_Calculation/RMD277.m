% load images
reconstruct('RMD277',[3 7]);
time_axis_hot=linspace(0+1,67-1,30);
temperature_measurements_hot=RMD277_Sc7_HOT.t_ave_uncorr(:,1,75,66);

% load Luxtron data
load(strcat(hotPath('luxtron'),'\RMD277 luxtron data'));
time_axis_lux=(s.timestamps_sec-s.timestamps_sec(1))/60;
temperature_measurements_lux=s.temperature_values(:,4);

% load calibration curve
load(hotPath('calibration'),'nu_of_T')

% compute RMSD
lux_bins_compare=findClosestTimeSamples(time_axis_lux,time_axis_hot);
rmsd_RMD277=sqrt(mean((temperature_measurements_lux(lux_bins_compare)-temperature_measurements_hot).^2));
temperature_measurements_hot_corr=temperature_measurements_hot-mean(temperature_measurements_hot(1:5))+mean(temperature_measurements_lux(lux_bins_compare(1:5)));
rmsd_rel_RMD277=sqrt(mean((temperature_measurements_lux(lux_bins_compare)-temperature_measurements_hot_corr).^2));

% look for correlation between lux and HOT
figure,scatter(temperature_measurements_lux(lux_bins_compare),nu_of_T(temperature_measurements_hot,7));
[cfun,gof]=fit(temperature_measurements_lux(lux_bins_compare),nu_of_T(temperature_measurements_hot,7),f,'Startpoint',[-3 1000]);
hold on
plot(cfun);
xlabel('Temperature (luxtron, \circC)');
ylabel('iZQC frequency (Hz)');
f=fittype('a*(T-37)+v','independent','T');
axis square
niceFigure(gcf);

f_h=figure;subplot(1,2,1);
imagesc(squeeze(abs(RMD277_Sc3_rare(1,:,:))));
axis image off
colormap gray
title('T_2-weighted image of marrow sample');

subplot(1,2,2);
scatter(time_axis_hot,temperature_measurements_hot,'k')
hold on
[haxis,hline1,hline2]=plotyy(time_axis_lux',temperature_measurements_lux,time_axis_lux',temperature_measurements_lux);
set(haxis(2),'YTickLabel',nu_of_T(str2num(get(haxis(1),'YTickLabel')),7));
axis(haxis,'square');
legend('MSE-HOT','Fiberoptic');
xlabel('time (min)');
ylabel(haxis(1),'temperature (\circC)','color','k');
ylabel(haxis(2),'iZQC frequency (Hz)','color','k');
set(haxis,'YColor','k');
set(hline2,'visible','off');
niceFigure(f_h);