%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


fs=18;

figure

subplot(1,3,1);
Figure4a_mse;
hold on
Figure4a_sli;
xlim([0 250]);
ylim([0 1.1]);
legend('MSE','SSE');
plot(15:240,feval(cfun_mse2_all,15:240),'b','LineWidth',2);
plot(15:140,feval(cfun_sli_all,15:140),'k','LineWidth',2);

subplot(1,3,2);
Figure4b;

subplot(1,3,3);
Figure4c;
Figure4c_determine_echo_averaging_weighting_curve;
xlim([0 250]);
ylim([-0.5 1]);
plot(10:250,feval(cfun_phase,10:250),'r');

set(gcf,'position',[53 378 1027 420]);