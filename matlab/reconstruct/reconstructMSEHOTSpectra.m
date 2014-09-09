function out = reconstructMSEHOTSpectra(directory)

recon_mat_size = [];

p_m = struct('Exp_type',[],'RARE_mode',[],'RARE_encoding_scheme',[]);
p_m = getPVEntry3([directory '\method'],p_m);

%% read and order raw data.  ordering involves putting all zq windows into
[~,td,hz1,hz2] = reconstructHOT2DSLI(directory);

%% sort data so that phase encoding in in 4th dim and coherence order is in
%% 3rd dim
td = resortHOTRARE2windows(td);

td(:,:,:,:,1) = 0;
spectra = fftshift(fftshift(fft(fft(ifftshift(ifftshift(td,2),5),recon_mat_size,2),recon_mat_size,5),2),5);
out=struct('time_domain_data',td,'spectra',spectra,'indirect_frequency_bins',hz1,'direct_frequency_bins',hz2);

%% display spectra:
if getHOTReconOption('display')
    figure
    for echo_num=1:size(spectra,3)/2
        subplot(ceil((size(spectra,3)/2)/4),4,echo_num)
        imagesc(abs(squeeze(spectra(1,:,echo_num,1,:))));
        axis image off
    end
end

figure,plot(squeeze(max(max(abs(spectra(1,1,1:end/2,:,:)),[],4),[],5)));
title('iZQC signal vs echo number');

function exp_dir =  getExpDirectory(directory)

ii = strfind(directory,'RMD');
ii_slash = strfind(directory(ii:end),'\');
exp_dir = directory(1:(ii+ii_slash(1) - 2));
