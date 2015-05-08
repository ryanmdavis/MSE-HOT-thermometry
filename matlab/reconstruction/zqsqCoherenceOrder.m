%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function determines which windows are zero or single quantum
% Input:
%   num_pi_pulses
%   varargin{1} - 2 for ZQSQ2, 3 for ZQSQ3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [zq_windows,sq_windows] = zqsqCoherenceOrder(num_pi_pulses,varargin)
if nargin == 1
    varargin{1} = 2;
end

switch varargin{1}
    case 2
        zq_windows=zeros(1,num_pi_pulses);
        sq_windows=zeros(1,num_pi_pulses);

        for pi_pulse_num=1:1:num_pi_pulses
            if mod(pi_pulse_num,2) %is odd
                zq_windows(pi_pulse_num)=2*pi_pulse_num-1; sq_windows(pi_pulse_num)=2*pi_pulse_num;
            else sq_windows(pi_pulse_num)=2*pi_pulse_num-1; zq_windows(pi_pulse_num)=2*pi_pulse_num;
            end
        end
    otherwise
        zq_windows = 2:num_pi_pulses;
        sq_windows = 1;
end