%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


%% RMD272

reconstruct('RMD272',18:29);
pt_272=[51 48;52 86;80 66];
sli_te_272=[11 15 20:10:60 80 100 120 140] + 2*3.15;
zq=zeros(11,5,128,128);
zq(1,:,:,:) =squeeze(RMD272_Sc18_HOT_MSE_ZQSQ3.pd(:,1,1,:,:));
zq(2,:,:,:) =squeeze(RMD272_Sc19_HOT_MSE_ZQSQ3.pd(:,1,1,:,:));
zq(3,:,:,:) =squeeze(RMD272_Sc20_HOT_MSE_ZQSQ3.pd(:,1,1,:,:));
zq(4,:,:,:) =squeeze(RMD272_Sc21_HOT_MSE_ZQSQ3.pd(:,1,1,:,:));
zq(5,:,:,:) =squeeze(RMD272_Sc22_HOT_MSE_ZQSQ3.pd(:,1,1,:,:));
zq(6,:,:,:) =squeeze(RMD272_Sc23_HOT_MSE_ZQSQ3.pd(:,1,1,:,:));
zq(7,:,:,:) =squeeze(RMD272_Sc24_HOT_MSE_ZQSQ3.pd(:,1,1,:,:));
zq(8,:,:,:) =squeeze(RMD272_Sc25_HOT_MSE_ZQSQ3.pd(:,1,1,:,:));
zq(9,:,:,:) =squeeze(RMD272_Sc26_HOT_MSE_ZQSQ3.pd(:,1,1,:,:));
zq(10,:,:,:)=squeeze(RMD272_Sc27_HOT_MSE_ZQSQ3.pd(:,1,1,:,:));
zq(11,:,:,:)=squeeze(RMD272_Sc28_HOT_MSE_ZQSQ3.pd(:,1,1,:,:));

% normalize to maximum of MSE data, and divide by 4 for the receiver gain
% difference:
sli_272_1=mean(abs(zq(:,:,pt_272(1,1),pt_272(1,2))),2)/max(abs(mean(RMD272_Sc29_HOT.pd(:,1,:,pt_272(1,1),pt_272(1,2)),1)),[],3)/4;
sli_272_2=mean(abs(zq(:,:,pt_272(2,1),pt_272(2,2))),2)/max(abs(mean(RMD272_Sc29_HOT.pd(:,1,:,pt_272(2,1),pt_272(2,2)),1)),[],3)/4;
sli_272_3=mean(abs(zq(:,:,pt_272(3,1),pt_272(3,2))),2)/max(abs(mean(RMD272_Sc29_HOT.pd(:,1,:,pt_272(3,1),pt_272(3,2)),1)),[],3)/4;

%% RMD273
reconstruct('RMD273',[20 23:32]);
pt_273=[62 84;63 51;83 63];

zq=zeros(10,5,128,128);
zq(1,:,:,:) =squeeze(RMD273_Sc23_HOT.pd(:,1,1,:,:));
zq(2,:,:,:) =squeeze(RMD273_Sc24_HOT.pd(:,1,1,:,:));
zq(3,:,:,:) =squeeze(RMD273_Sc25_HOT.pd(:,1,1,:,:));
zq(4,:,:,:) =squeeze(RMD273_Sc26_HOT.pd(:,1,1,:,:));
zq(5,:,:,:) =squeeze(RMD273_Sc27_HOT.pd(:,1,1,:,:));
zq(6,:,:,:) =squeeze(RMD273_Sc28_HOT.pd(:,1,1,:,:));
zq(7,:,:,:) =squeeze(RMD273_Sc29_HOT.pd(:,1,1,:,:));
zq(8,:,:,:) =squeeze(RMD273_Sc30_HOT.pd(:,1,1,:,:));
zq(9,:,:,:) =squeeze(RMD273_Sc31_HOT.pd(:,1,1,:,:));
zq(10,:,:,:)=squeeze(RMD273_Sc32_HOT.pd(:,1,1,:,:));

sli_273_1=mean(abs(zq(:,:,pt_273(1,1),pt_273(1,2))),2)/max(abs(mean(RMD273_Sc20_HOT.pd(:,1,:,pt_273(1,1),pt_273(1,2)),1)),[],3);
sli_273_2=mean(abs(zq(:,:,pt_273(2,1),pt_273(2,2))),2)/max(abs(mean(RMD273_Sc20_HOT.pd(:,1,:,pt_273(2,1),pt_273(2,2)),1)),[],3);
sli_273_3=mean(abs(zq(:,:,pt_273(3,1),pt_273(3,2))),2)/max(abs(mean(RMD273_Sc20_HOT.pd(:,1,:,pt_273(3,1),pt_273(3,2)),1)),[],3);

%% now put all SLI data into one matrix with matching TE values
% because different datasets have different TE values, use
% TE=15,30,40,50,60,80,100,120,140ms

TE_sli=[15 30 40 50 60 80 100 120 140];
bins_272=[1 3 4 5 6 8 9 10 11];
bins_273=[1 3 4 5 6 7 8 9 10];

sli_abs_all=[sli_272_1(bins_272)';sli_272_2(bins_272)';sli_272_3(bins_272)';sli_273_1(bins_273)';sli_273_2(bins_273)';sli_273_3(bins_273)'];
errorbar(TE_sli,mean(sli_abs_all,1),std(sli_abs_all,[],1),'kx','MarkerSize',15);
xlabel('echo time (ms)','FontSize',fs);
ylabel('iZQC signal (a.u.)','FontSize',fs);
set(gca,'FontSize',fs-3);
axis square

%% fit the data
f = fittype('a*x*exp(-x/abs(b))');
[cfun_sli_all,gof_sli_all]=fit(TE_sli',mean(sli_abs_all,1)',f,'StartPoint',[0.1 40]);
