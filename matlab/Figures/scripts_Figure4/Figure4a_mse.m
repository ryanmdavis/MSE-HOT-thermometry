%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


%% general imaging parameters
t0=1.7;%ms
te=15;%ms
num_mse2_pi_pulses=20;
time_bw_rfc_pulse_mse2=11.6;
[mse2_zq_windows,mse2_sq_windows] = zqsqCoherenceOrder(num_mse2_pi_pulses);
mse2_te=te-2*t0+time_bw_rfc_pulse_mse2*(mse2_zq_windows(1:num_mse2_pi_pulses)-1)/2;

%% RMD273
setHOTReconOption('decomposition','off','recon_size',128);
reconstruct('RMD273',20);
pt1=[62 84];
pt2=[63 51];
pt3=[83 63];

zqsq_Sc20=RMD273_Sc20_HOT.pd;
zqsq_Sc20_mean=squeeze(mean(abs(zqsq_Sc20(:,1,:,:,:)),1));
s273_1=squeeze(abs(zqsq_Sc20_mean(:,pt1(1),pt1(2)))/max(abs(zqsq_Sc20_mean(:,pt1(1),pt1(2)))));
s273_2=squeeze(abs(zqsq_Sc20_mean(:,pt2(1),pt2(2)))/max(abs(zqsq_Sc20_mean(:,pt2(1),pt2(2)))));
s273_3=squeeze(abs(zqsq_Sc20_mean(:,pt3(1),pt3(2)))/max(abs(zqsq_Sc20_mean(:,pt3(1),pt3(2)))));

f = fittype('a*x*exp(-x/abs(b))');
[cfun_273_1,gof_273_1] = fit(mse2_te',s273_1,f,'StartPoint',[0.1 40]);
[cfun_273_2,gof_273_2] = fit(mse2_te',s273_2,f,'StartPoint',[0.1 40]);
[cfun_273_3,gof_273_3] = fit(mse2_te',s273_3,f,'StartPoint',[0.1 40]);

%% RMD274
reconstruct('RMD274',6);
pt1=[51 90];
pt2=[51 56];
pt3=[81 71];

zqsq_Sc6=RMD274_Sc6_HOT.pd;
zqsq_Sc6_mean=squeeze(mean(abs(zqsq_Sc6(:,1,:,:,:)),1));
s274_1=zeros(20,1);
s274_2=zeros(20,1);
s274_3=zeros(20,1);
s274_1(1:16)=squeeze(abs(zqsq_Sc6_mean(:,pt1(1),pt1(2)))/max(abs(zqsq_Sc6_mean(:,pt1(1),pt1(2)))));
s274_2(1:16)=squeeze(abs(zqsq_Sc6_mean(:,pt2(1),pt2(2)))/max(abs(zqsq_Sc6_mean(:,pt2(1),pt2(2)))));
s274_3(1:16)=squeeze(abs(zqsq_Sc6_mean(:,pt3(1),pt3(2)))/max(abs(zqsq_Sc6_mean(:,pt3(1),pt3(2)))));

f = fittype('a*x*exp(-x/abs(b))');
[cfun_274_1,gof_274_1] = fit(mse2_te(1:16)',s274_1(1:16),f,'StartPoint',[0.1 40]);
[cfun_274_2,gof_274_2] = fit(mse2_te(1:16)',s274_2(1:16),f,'StartPoint',[0.1 40]);
[cfun_274_3,gof_274_3] = fit(mse2_te(1:16)',s274_3(1:16),f,'StartPoint',[0.1 40]);

%% RMD275
reconstruct('RMD275',30)
pt1=[55 37];
pt2=[73 89];
pt3=[78 58];

zqsq_Sc30=RMD275_Sc30_HOT.pd;
zqsq_Sc30_mean=squeeze(mean(abs(zqsq_Sc30(:,1,:,:,:)),1));
s275_1=squeeze(abs(zqsq_Sc30_mean(:,pt1(1),pt1(2)))/max(abs(zqsq_Sc30_mean(:,pt1(1),pt1(2)))));
s275_2=squeeze(abs(zqsq_Sc30_mean(:,pt2(1),pt2(2)))/max(abs(zqsq_Sc30_mean(:,pt2(1),pt2(2)))));
s275_3=squeeze(abs(zqsq_Sc30_mean(:,pt3(1),pt3(2)))/max(abs(zqsq_Sc30_mean(:,pt3(1),pt3(2)))));

%% put all data into one variable:
s_all=[s273_1/max(s273_1),s273_2/max(s273_2),s273_3/max(s273_3),s274_1/max(s274_1),s274_2/max(s274_2),s274_3/max(s274_3),s275_1/max(s275_1),s275_2/max(s275_2),s275_3/max(s275_3)];

%% fit the data

f = fittype('a*x*exp(-x/abs(b))');
[cfun_275_1,gof_275_1] = fit(mse2_te',s275_1,f,'StartPoint',[0.1 40]);
[cfun_275_2,gof_275_2] = fit(mse2_te',s275_2,f,'StartPoint',[0.1 40]);
[cfun_275_3,gof_275_3] = fit(mse2_te',s275_3,f,'StartPoint',[0.1 40]);

T2e=[cfun_273_1.b cfun_273_2.b cfun_273_3.b cfun_274_1.b cfun_274_2.b cfun_274_3.b cfun_275_1.b cfun_275_2.b cfun_275_3.b];
a=[cfun_273_1.a cfun_273_2.a cfun_273_3.a cfun_274_1.a cfun_274_2.a cfun_274_3.a cfun_275_1.a cfun_275_2.a cfun_275_3.a];

[cfun_mse2_all,gof_mse2_all] = fit(mse2_te',mean(s_all,2),f,'StartPoint',[0.1 40]);

%% display result
errorbar(mse2_te,mean(s_all,2),std(s_all,0,2),'bo');
xlabel('echo time (ms)','FontSize',fs);
ylabel('iZQC signal (a.u.)','FontSize',fs);
set(gca,'FontSize',fs-3);
axis square