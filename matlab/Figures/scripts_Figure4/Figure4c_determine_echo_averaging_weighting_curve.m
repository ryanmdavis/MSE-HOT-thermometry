%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


%% fit the signal vs time curves
% mse2_S_vs_t_curve;
s_data=mean(s_all,2);
f_signal=fittype('a*x*exp(-x/abs(T))');
[cfun_signal,gof_signal]=fit(TE_mse',s_data,f_signal,'StartPoint',[40 0.1]);

%% fit the phase vs time curves
% mse2_phase_vs_t_curve;
f_phase=fittype('a*x^2+b*x+c');
[cfun_phase,gof_phase]=fit(TE_mse',mean(phase_all_mse,2),f_phase,'StartPoint',[0 0 mean(mean(phase_all_mse))],'weights',s_data);

% load(hotPath('calibration'),'S_of_TE','T_of_nu','nu_of_T')
% S_of_TE=@(t_ms)0.04622*t_ms.*exp(-t_ms/57.31).*exp(-1i*((-2.039e-05)*t_ms.^2+0.006899*t_ms-0.188));
% T_of_nu=@(nu,fs)((7/fs)*nu-1008)/(-3)+37;
% nu_of_T=@(T,fs)(fs/7)*(-3*(T-37)+1008);
% save(hotPath('calibration'),'S_of_TE','T_of_nu','nu_of_T');