%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


%% CPMG figure
norm_point=16; %all methylene peaks are normalized to this datapoint

%% load 360 MHz experimental 1H spectra of oleic acid, palmitic acid, and cholesteryl benzoate at 360 MHz
Figure5c_lipid_spectra_360MHz;

%% load experimental 1T
Figure5_analyze_fat_water_1T
error_1T_exp=std(normalized_1T_water_exp)*ones(size(normalized_1T_water_exp));
normalized_1T_oleic_exp=normalized_1T_oleic_exp/normalized_1T_oleic_exp(norm_point);
normalized_1T_water_exp=normalized_1T_water_exp/normalized_1T_water_exp(norm_point);

%% load simulation 1T
methylene_1T_sim_s=load(strcat(hotPath('sim'),'1T methylene peaks - simulation -  oleic acid.mat'));
methylene_1T_sim=methylene_1T_sim_s.d075Int_40_1T/methylene_1T_sim_s.d075Int_40_1T(norm_point);

%% load simulations 7T
% H1
methylene=load(strcat(hotPath('sim'),'totalfid'));
methylene_7T_sim_H1=zeros(5,20);
methylene_7T_sim_H1(1,:)= methylene.totalfid.d000/methylene.totalfid.d000(norm_point);
methylene_7T_sim_H1(2,:)= methylene.totalfid.d025/methylene.totalfid.d025(norm_point);
methylene_7T_sim_H1(3,:)= methylene.totalfid.d050/methylene.totalfid.d050(norm_point);
methylene_7T_sim_H1(4,:)= methylene.totalfid.d075/methylene.totalfid.d075(norm_point);
methylene_7T_sim_H1(5,:)= methylene.totalfid.d100/methylene.totalfid.d100(norm_point);
%H2
methylene_H2=load(strcat(hotPath('sim'),'7T methylene peaks - simulation - H2 - oleic acid.mat'));
methylene_7T_sim_H2=methylene_H2.csCOSY_int_7T/max(methylene_H2.csCOSY_int_7T(norm_point));

%% load experimental 7T
exp=load(strcat(hotPath('sim'),'7t data - soy-oleic-water.mat'));
normalized_7T_oleic_exp=exp.soybean_oil/exp.soybean_oil(norm_point);
normalized_7T_water_exp=exp.water/exp.water(norm_point);
error_7T_exp=exp.error/exp.soybean_oil(1);

num_pulses=zeros(5,20);
num_pulses(1,:)=1:20;
num_pulses(2,:)=1:20;
num_pulses(3,:)=1:20;
num_pulses(4,:)=1:20;
num_pulses(5,:)=1:20;

%% general figure params
f_h=figure;
set(gcf,'position',[161 219 979 594]);
legend_on=1;
ms=10;

%% Show CPMG of various compounds @ 7T
subplot(2,3,1);
Figure5_analyze_fat_water_7T;
if legend_on legend('H_2O','PA','OA','CB'); end
xlabel('number of \pi pulses');
ylabel('-CH_2-  signal (a.u.)');
axis square
ylim([0.4 1.1]);
xlim([1 12]);

%% show CPMG of various compounds at 1T
subplot(2,3,2);
errorbar(1:16,normalized_1T_water_exp,error_1T_exp,'ko','MarkerSize',ms-4);
hold on
errorbar(1:16,normalized_1T_palmitic_exp,error_1T_exp,'b*','MarkerSize',ms);
errorbar(1:16,normalized_1T_oleic_exp,error_1T_exp,'rx','MarkerSize',ms);
errorbar(1:16,normalized_1T_cholesteryl_exp,error_1T_exp,'g+','MarkerSize',ms);

if legend_on legend('H_2O','PA','OA','CB'); end
xlabel('number of \pi pulses');
ylabel('-CH_2-  signal (a.u.)');
axis square
ylim([0.4 1.1]);
xlim([1 16]);

%% show 1H spectra at 360 MHz
subplot(2,3,3);
methyl_bins=125505:135008;
plot(hz(methyl_bins)/360,real(oleic_360MHz(methyl_bins))/max(real(oleic_360MHz(methyl_bins))),'r');
hold on
plot(hz(methyl_bins)/360,real(palmitic_360MHz(methyl_bins))/max(real(palmitic_360MHz(methyl_bins))),'b');
plot(hz(methyl_bins)/360,real(cholesteryl_360MHz(methyl_bins))/max(real(cholesteryl_360MHz(methyl_bins))),'g');
xlabel('res. freq. (ppm)');
ylabel('intensity (a.u.)');
ylim([0 1.1]);
set(gca,'xdir','reverse');
axis square
if legend_on legend('OA','PA','CB'); end
xlim([hz(min(methyl_bins))/360 hz(max(methyl_bins))/360]);

% show H1 for various values of d
subplot(2,3,4);
c={'k','b','r','g','m'};
for d=5:-1:1
    plot(methylene_7T_sim_H1(6-d,:)',c{d})
    hold on
end
for d=5:-1:1
    scatter(1:20,methylene_7T_sim_H1(6-d,:),c{d})
end
axis square
ylim([0.4 1]);
if legend_on legend('d=0','d=0.25','d=0.5','d=0.75','d=1'); end
xlabel('number of \pi pulses');
ylabel('-CH_2- signal (a.u.)');

%% 7T data and simulations
subplot(2,3,5);
sim_num=4;

errorbar(1:16,normalized_7T_oleic_exp',error_7T_exp,'kx','MarkerSize',ms);
hold on
scatter(1:20,methylene_7T_sim_H1(sim_num,:),'bo','SizeData',ms*4);
scatter(1:20,methylene_7T_sim_H2,'r*','SizeData',ms*4);
axis square
if legend_on legend('OA','H_1;d=0.75','H_2'); end
ylim([0.4 1]);
xlabel('number of \pi pulses');
ylabel('-CH_2- signal (a.u.)');

%% 1T data and simulations
subplot(2,3,6)
errorbar(1:16,normalized_1T_oleic_exp',error_1T_exp,'kx','MarkerSize',ms);
hold on
scatter(1:20,methylene_1T_sim,'bo','SizeData',ms*4);
axis square
if legend_on legend('OA','H_1;d=0.75'); end
ylim([0.4 1]);
xlabel('number of \pi pulses');
ylabel('-CH_2- signal (a.u.)');

niceFigure(gcf,'fs',15);