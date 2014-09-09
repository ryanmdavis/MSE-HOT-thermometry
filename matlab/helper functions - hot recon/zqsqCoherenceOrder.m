%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function determines which windows are zero or single quantum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [zq_windows,sq_windows] = zqsqCoherenceOrder(num_pi_pulses)

zq_windows=zeros(1,num_pi_pulses);
sq_windows=zeros(1,num_pi_pulses);

for pi_pulse_num=1:1:num_pi_pulses
    if mod(pi_pulse_num,2) %is odd
        zq_windows(pi_pulse_num)=2*pi_pulse_num-1; sq_windows(pi_pulse_num)=2*pi_pulse_num;
    else sq_windows(pi_pulse_num)=2*pi_pulse_num-1; zq_windows(pi_pulse_num)=2*pi_pulse_num;
    end
end