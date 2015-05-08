%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


function varargout = reconstructHOT2DSLI(raw_data_folder,varargin)

invar = struct('recon_mat_size',[]);
argin = varargin;
invar = generateArgin(invar,argin);

fid1=fopen([raw_data_folder '\fid'],'r','l');   %Open fid
%Read fid data as single line; scale by 2^16 to match word size of PV
fidmix1=fread(fid1,inf,'int32');

%********************Gather RARE parameters*******************
p_m = struct('phase_mat_size',[],'PVM_SpecMatrix',[],'tau_inc',[],'tau_min',[],'tau_max',[],'PVM_SpecAcquisitionTime',[],'PVM_DigShift',[],'exp_reps',[],'num_echoes',1,'num_echoes_SQ',[],'meas_rec_baseline_OnOff','Off ','RARE_mode',[]);
p_m = getPVEntry3([raw_data_folder '\method'],p_m);
if isempty(p_m.num_echoes_SQ) p_m.num_echoes_SQ=p_m.num_echoes; end
p_a = struct('NI',[]);
p_a = getPVEntry3([raw_data_folder '\acqp'],p_a);
NpointPE = p_m.phase_mat_size;
NpointRD_acquired = p_m.PVM_SpecMatrix;
num_points_minus_baseline = size(fidmix1,1);
num_baseline_windows = 0;
if strcmp(p_m.RARE_mode,'one_image ')
        NpointPE = NpointPE/p_m.num_echoes;
%     num_normal_windows = p_a.NI*NpointPE*p_m.tau_inc*p_m.exp_reps;
else

%     num_normal_windows = 2*NpointPE*p_m.tau_inc*p_m.exp_reps;
end
num_normal_windows = p_a.NI*NpointPE*p_m.tau_inc*p_m.exp_reps;

if strcmp(p_m.meas_rec_baseline_OnOff,'On ');
    num_baseline_windows = p_a.NI;
end 
%NpontsRD is the number of actual complex numbered samples, PV usually zero pads
%this to a power of 2.
NpointRD = size(fidmix1,1)/(2*(num_normal_windows + num_baseline_windows)); % because PV pads the acquisitons if number of readout samples ~= 2^N
%remove the baseline samples for correcting the DC receiver artefact:
if strcmp(p_m.meas_rec_baseline_OnOff,'On ');
    baseline = fidmix1(1:2*NpointRD*num_baseline_windows);
    baseline_complex = baseline(1:2:end) + 1i*baseline(2:2:end);
    baseline_complex = reshape(baseline_complex,size(baseline_complex,1)/(p_a.NI),p_a.NI);
    baseline_mean = mean(mean(baseline_complex(1:p_m.PVM_SpecMatrix,:)));
else baseline_mean = 0;
end
fidmix1 = fidmix1(2*NpointRD*num_baseline_windows+1:end);

%******************** Processing - Image 1 *******************************
raw = reshape(fidmix1,2,NpointRD*num_normal_windows);   %Reshape data into real and imaginary components
raw_complex = raw(1,:)+1i*raw(2,:);             %Combine data from real and imaginary components
%%% reorder dimensions as: repetition,window,delay,phase,read. Will switch
%%% the window and delay dimensions below (line 65-66)
k_space_big = double(flipdim(permute(reshape(raw_complex,NpointRD,p_a.NI,NpointPE,p_m.tau_inc,p_m.exp_reps),[5 2 4 3 1]),4));

%remove spikes
k_space_big(abs(k_space_big)>2^24) = 0;
if nargin == 2 start = varargin{1};
elseif strcmp(p_m.meas_rec_baseline_OnOff,'Off ') start = p_m.PVM_DigShift; 
else start = 0;
end
% k_space_big(:,1,abs(k_space_big(:,1,:)) > mean(reshape(abs(k_space_big(:,1,:)),1,numel(k_space_big(:,1,:)))+10*std(reshape(abs(k_space_big(:,1,:)),1,numel(k_space_big(:,1,:)))))) = 0;
% k_space_big(:,2,abs(k_space_big(:,2,:)) > mean(reshape(abs(k_space_big(:,2,:)),1,numel(k_space_big(:,2,:)))+10*std(reshape(abs(k_space_big(:,2,:)),1,numel(k_space_big(:,2,:)))))) = 0;
k_space = k_space_big(:,:,:,:,start+1:NpointRD_acquired-start);
k_space = k_space - baseline_mean;

spectra = fftshift(fftshift(fft(fft(k_space,invar.recon_mat_size,4),invar.recon_mat_size,5),4),5);

k_space = permute(k_space,[1 3 2 4 5]);
spectra = permute(spectra,[1 3 2 4 5]);   

sw_f1 = 1000*p_m.tau_inc/(p_m.tau_max - p_m.tau_min);
hz_f1 = -sw_f1/2:sw_f1/(p_m.tau_inc - 1):sw_f1/2;

sw_f2 = 1000*NpointRD_acquired/p_m.PVM_SpecAcquisitionTime;
hz_f2 = -sw_f2/2:sw_f2/(NpointRD_acquired-1):sw_f2/2;
fclose(fid1);
if nargout >= 1
    varargout{1} = spectra;
end
if nargout >= 2
    varargout{2} = k_space;
end
if nargout >= 3
    varargout{3} = hz_f1;
end
if nargout >=4
    varargout{4} = hz_f2;
end