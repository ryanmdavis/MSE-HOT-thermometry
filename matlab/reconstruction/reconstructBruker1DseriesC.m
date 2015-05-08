%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


%%%This function is intended to reconstruct a series of spectra where an
%%%unintended buffer at the end of each acquisition has been added by the
%%%bruker console.  This is the distinction betweek "nominal" and "actual"
%%%number of samples

function varargout = reconstructBruker1DseriesC(folder)

% BRUKER_FILE='C:\Users\Ryan\Documents\Duke Work\Bruker 7T data\RMD11\17\fid';  %This is the FID (or SER) file from the spectrometer
recon_mat_factor=4;
%*************************************************************************
p_acqp = struct('ACQ_size',[],'SW',[],'NI',[],'NR',[]);
p_acqp = getPVEntry3([folder '\acqp'],p_acqp);
p_method = struct('PVM_NRepetitions',[],'PVM_DigShift',[]);
p_method = getPVEntry3([folder '\method'],p_method);
if ~isempty(p_method.PVM_NRepetitions)
    num_fid = p_method.PVM_NRepetitions;
else num_fid = p_acqp.NR; 
end
spectral_width = p_acqp.SW;

%calculate spectral res & width


fid=fopen([folder '\fid'],'r','l'); %opens the data file
if fid == -1
    fid=fopen([folder '\ser'],'r','l'); %opens the data file
end
rawbuf=fread(fid,inf,'int32');  %reads data as a single line
num_samples_actual = size(rawbuf,1)/num_fid;
num_samples_nominal = p_acqp.ACQ_size(1);
samples_buffered = num_samples_nominal - num_samples_actual;
spectrum = zeros(num_fid,recon_mat_factor*num_samples_nominal/2);

dir_fres=spectral_width/(num_samples_nominal/2-1);               
dir_swaxis=(-.5*spectral_width):dir_fres:(.5*spectral_width);

trunc = zeros(size(spectrum));
for fid_num = 1:num_fid
    fid_start = (fid_num-1) * num_samples_actual + 1;
    fid_this = rawbuf(fid_start:fid_start + num_samples_nominal - 1);
    
    fidmix=reshape(fid_this,2,num_samples_nominal/2);    %reshapes the data in real and imaginary data

    re=fidmix(1,:);   %real is first Npoint points of data
    im=fidmix(2,:);   %imag is second Npoint points of data

    fidcom=zeros(1,size(spectrum,2));
    fidcom(1:num_samples_nominal/2)=re + 1i*im; %Combines real and imaginary data
%     fidcom_abs = abs(fidcom);

    spectrum(fid_num,:) = fftshift(fft(circshift(fidcom,[0 -p_method.PVM_DigShift])));   %Fourier Transform of combined data
    trunc(fid_num,:) = (fftshift(fft(fidcom)));
end

varargout{1} = spectrum;
if nargout>=2
    varargout{2} = dir_swaxis;
    if nargout>=3
        varargout{3} = trunc;
    end
end
