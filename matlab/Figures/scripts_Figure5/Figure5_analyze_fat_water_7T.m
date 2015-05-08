%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


chloroform_ppm=7.256;

path=hotPath('images');
exp_dir=strcat(path{1},'\RMD286.sl1\');

%% cholesteryl benzoate
cb_chloroform_ppm=6.366; %ppm of chlorofom of this experiment, based on spectrometer frequency
[~,cholesteryl_benzoate]=reconstructCPMG(strcat(exp_dir,'51'),[0.6 1.7],chloroform_ppm-cb_chloroform_ppm);

%% palmitic acid
pa_chloroform_ppm=6.022;
[~,palmitic_acid]=reconstructCPMG(strcat(exp_dir,'20'),[0.6 1.7],chloroform_ppm-pa_chloroform_ppm);

%% oleic acid
oa_chloroform_ppm=6.022;
[~,oleic_acid]=reconstructCPMG(strcat(exp_dir,'14'),[0.6 1.7],chloroform_ppm-oa_chloroform_ppm);

%% water & error
[~,water]=reconstructCPMG(strcat(exp_dir,'10'));
error=std(water)*ones(size(water));

% figure
errorbar(1:12,water/water(end),error,'ko','MarkerSize',ms-4);
hold on
errorbar(1:12,palmitic_acid/palmitic_acid(end),error,'bx','MarkerSize',ms);
errorbar(1:12,oleic_acid/oleic_acid(end),error,'r*','MarkerSize',ms);
errorbar(1:12,cholesteryl_benzoate/cholesteryl_benzoate(end),error,'g+','MarkerSize',ms);
axis square
% niceFigure(gcf);