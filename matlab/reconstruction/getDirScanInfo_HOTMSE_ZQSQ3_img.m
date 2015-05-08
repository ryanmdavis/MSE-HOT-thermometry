%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


function out = getDirScanInfo_HOTMSE_ZQSQ3_img(directory,kspace)

%% read in information about image
p_m = struct('Exp_type',[],'t1',[],'tau_min',[],'tau_max',[],'num_echoes',[],'num_echoes_SQ',[]);
p_m = getPVEntry3([directory '\method'],p_m);
kspace=flipdim(kspace,4);

%% shift to laboratory frame
[r1,c1]=maxRowColIndex(abs(squeeze(kspace(1,1,1,:,:))));
[r2,c2]=maxRowColIndex(abs(squeeze(kspace(1,1,2,:,:))));
angle1=angle(kspace(1,1,1,r1,c1));
angle2=angle(kspace(1,1,1,r2,c2));
angle_lab=mean([angle1 angle2]);
kspace=kspace*exp(-1i*angle_lab);

%% filter k-space data
[max_row,max_col] = maxRowColIndex(squeeze(kspace(1,1,1,:,:)));
f_surf_norm = reshape(makeFermiSurface([size(kspace,4) size(kspace,5)],[5 5],[1 1],[max_row max_col]),1,1,1,size(kspace,4),size(kspace,5));
for delay_number = 1:size(kspace,2)
    for time_point = 1:size(kspace,1)
        for echo_number = 1:p_m.num_echoes_SQ+p_m.num_echoes
            kspace(time_point,delay_number,echo_number,:,:) = kspace(time_point,delay_number,echo_number,:,:).*f_surf_norm;
        end
    end
end

im = fftshift(fftshift(ifft(ifft(ifftshift(ifftshift(kspace,4),5),[],4),[],5),4),5);
im=upsampleImage(im,4);
pd = zeros(size(im,1),size(im,2),p_m.num_echoes,size(im,4),size(im,5));

%% make phase corrections
for timepoint = 1:size(im,1)
    for delay_num=1:size(im,2)
        for zq_echo_num=p_m.num_echoes_SQ+1:p_m.num_echoes_SQ+p_m.num_echoes
            if mod(zq_echo_num-p_m.num_echoes_SQ,2) %is odd?
                pd(timepoint,delay_num,zq_echo_num-p_m.num_echoes_SQ,:,:) = im(timepoint,delay_num,zq_echo_num,:,:).*exp(1i*angle(conj(im(timepoint,delay_num,1,:,:))))*exp(1i*pi/2);
            else
                pd(timepoint,delay_num,zq_echo_num-p_m.num_echoes_SQ,:,:) = conj(im(timepoint,delay_num,zq_echo_num,:,:).*exp(1i*angle(conj(im(timepoint,delay_num,1,:,:)))))*exp(-1i*pi/2);
            end
        end
    end
end

[temperature_data,frequency_data]=imagesToTempNT_PD(angle(pd),directory);

out=struct('im',im,'k',kspace,'t',temperature_data,'nu',frequency_data,'pd',pd);

% % display image and k-space
% f_i = figure;
% f_k = figure;
% 
% for echo_num = 0:p_m.num_echoes-1
%     figure(f_i);
%     subplot(5,4,echo_num+1)
%     imagesc(abs(squeeze(im(1,1,echo_num+p_m.num_echoes_SQ+1,:,:))));%,[0  15]);
%     title(strcat('echo ',num2str(echo_num+1),' - iZQC'),'FontSize',15)
%     set(gca,'FontSize',15);
%     axis square off
%     figure(f_k);
%     subplot(5,4,echo_num+1)
%     imagesc(abs(squeeze(kspace(1,1,echo_num+p_m.num_echoes_SQ+1,:,:))));%,[0 max_iZQC_k]);
%     title(strcat('echo ',num2str(echo_num+1),' - iZQC'),'FontSize',15)
%     set(gca,'FontSize',15);
%     axis square off
% end