%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


function out=reconstructMSEHOTImages(directory)

p_m = struct('num_echoes',[],'t1',[],'tau_min',[],'time_bw_rfc_pulses',[],'TE_ms',[]);
p_m = getPVEntry3([directory '\method'],p_m);
p_a = struct('ACQ_vd_list',[]);
p_a = getPVEntry3([directory '\acqp'],p_a);
evolution_time=parseVdList(p_a.ACQ_vd_list);
[zq_windows,sq_windows] = zqsqCoherenceOrder(p_m.num_echoes);


[~,k] = reconstructHOT2DSLI(directory);
k=flipdim(k,4);
[max_row,max_col] = maxRowColIndex(squeeze(k(1,1,2,:,:)));
fermi_T=getHOTReconOption('fermi_T');
fermi_E=getHOTReconOption('fermi_E');
f_surf_norm = reshape(makeFermiSurface([size(k,4) size(k,5)],[fermi_E fermi_E],[fermi_T fermi_T],[max_row max_col]),1,1,1,size(k,4),size(k,5));
k=circshift(k,[0 0 0 floor(-max_row+1+size(k,4)/2) -max_col+1+size(k,5)/2]);
for timepoint = 1:size(k,1);
    for delay_num=1:size(k,2);
        for zq_echo_num=1:size(zq_windows,2) 
            k(timepoint,delay_num,zq_windows(zq_echo_num),:,:) = k(timepoint,delay_num,zq_windows(zq_echo_num),:,:).*f_surf_norm;
            k(timepoint,delay_num,sq_windows(zq_echo_num),:,:) = k(timepoint,delay_num,sq_windows(zq_echo_num),:,:).*f_surf_norm;
        end
    end
end

%% use zero filling to make the reconstruction matrix the correct size
im=fftshift(fftshift(ifft(ifft(fftshift(fftshift(k,4),5),[],4),[],5),4),5);
recon_size=getHOTReconOption('recon_size');
image_size=[size(im,4) size(im,5)];
zf_factor=min(recon_size./image_size);
im=upsampleImage(im,zf_factor);

%% phase the iZQC images to the closest SQC echo
%the following correctly phases alternating echoes in the image domain
pd = zeros(size(im,1),size(im,2),size(im,3)/2,size(im,4),size(im,5));
for timepoint = 1:size(k,1)
    for delay_num=1:size(k,2)
        for zq_echo_num=1:size(zq_windows,2)
            if mod(zq_echo_num,2) %is odd?
                pd(timepoint,delay_num,zq_echo_num,:,:) = im(timepoint,delay_num,zq_windows(zq_echo_num),:,:).*exp(-1i*angle(im(timepoint,delay_num,sq_windows(zq_echo_num),:,:)))*exp(1i*pi/2);
            else
                pd(timepoint,delay_num,zq_echo_num,:,:) = conj(im(timepoint,delay_num,zq_windows(zq_echo_num),:,:).*exp(-1i*angle(im(timepoint,delay_num,sq_windows(zq_echo_num),:,:)))*exp(-1i*pi/2));
            end
        end
    end
end
[t,nu]=imagesToTempNT_PD(angle(pd),directory);

%% take the weighted average of the phased (pd) images and convert to temperature
load(hotPath('calibration'),'S_of_TE');
average=zeros(size(pd,1),size(pd,2),size(pd,4),size(pd,5));
[mse2_zq_windows,~] = zqsqCoherenceOrder(p_m.num_echoes);
te=p_m.TE_ms-2*p_m.t1+p_m.time_bw_rfc_pulses*(mse2_zq_windows(1:p_m.num_echoes)-1)/2;
weights=S_of_TE(te);
for zq_echo_num=1:min([size(zq_windows,2) getHOTReconOption('num_echoes_avg')])
    average=average+weights(zq_echo_num)*reshape(pd(:,:,zq_echo_num,:,:),size(pd,1),size(pd,2),size(pd,4),size(pd,5));
end
t_ave_uncorr=imagesToTempNT_PD(angle(average),directory);
out=struct('im',im,'k',k,'t',t,'nu',nu,'pd',pd,'t_ave_uncorr',t_ave_uncorr,'pd_ave',average,'pd_ave_corr',[]);

%% perform correction for unwanted peaks in spectrum (e.g. olefinic and 0Hz contamination)
decomposition_value = getHOTReconOption('decomposition');
if strcmp(decomposition_value,'use saved') && ~exist(strcat(directory,'/decomposition.mat'),'file')
    warning('no saved decomposition found, calculating decomposition anew');
    decomposition_value = 'calculate';
end

% load or calculate decomposition if necessary
switch decomposition_value
    case 'use saved'
        if exist(strcat(directory,'/decomposition.mat'),'file')
            load(strcat(directory,'/decomposition'));
            out.decomposition=decomposition; %#ok<NODEF>
        else
            error('no decomposition file found');
        end
        
    case 'calculate'
        setHOTReconOption('decomposition','off');
        decomposition = decompose3ComponentImageCSI(findExpNameBruker(directory),str2num(getHOTReconOption('decomposition_scan')));
        setHOTReconOption('decomposition',decomposition_value);
        
        % save decomposition in CSI and HOT image directory
        save(strcat(directory,'\decomposition'),'decomposition');
        slash_loc=strfind(directory,'\');
        directory_CSI=strcat(directory(1:slash_loc(end)),getHOTReconOption('decomposition_scan'));
        save(strcat(directory_CSI,'\decomposition'),'decomposition');
        out.decomposition=decomposition;
end

% now subtract the unwanted components of the signal from the images
if ~strcmp(getHOTReconOption('decomposition'),'off')
    a=decomposition.cfun_par_map.a;
    b=decomposition.cfun_par_map.b;
    c=decomposition.cfun_par_map.c;
    t2w=decomposition.cfun_par_map.t2w;
    t2o=decomposition.cfun_par_map.t2o;
    po=decomposition.cfun_par_map.po;
    pw=decomposition.cfun_par_map.pw;
    vo=decomposition.cfun_par_map.vo;
    vw=decomposition.cfun_par_map.vw;

    s_olef_f=@(b,t2o,vo,po,t_s)(exp(-t_s./real(t2o)).*real(b).*sin(2*pi*real(vo)*t_s+real(po)+pi/2)+1i*exp(-t_s./imag(t2o)).*imag(b).*sin(2*pi*imag(vo)*t_s+imag(po)));
    s_water_f=@(a,t2w,vw,pw,t_s)(exp(-t_s./real(t2w)).*real(a).*sin(2*pi*real(vw)*t_s+real(pw)+pi/2)+1i*exp(-t_s./imag(t2w)).*imag(a).*sin(2*pi*imag(vw)*t_s+imag(pw)));
    average_corr=zeros(size(average));
    s=[1 1 size(decomposition.o)];
    o=reshape(decomposition.o,s);
    z=reshape(decomposition.z,s);
%     warning('only subtracting 0Hz')
    for rep_number=1:size(average,1)
        for delay_number=1:size(average,2)
            % subtract the olefinic and zero Hertz component
            s_olef=reshape(s_olef_f(b,t2o,vo,po,evolution_time(delay_number)),s);
            s_water=s_water_f(a,t2w,vw,pw,evolution_time(delay_number));
            average_corr(rep_number,delay_number,:,:)=average(rep_number,delay_number,:,:)-s_olef-reshape(c,s);
            
            %old method % average_corr(rep_number,delay_number,:,:)=average(rep_number,delay_number,:,:)-z-o;
        end
    end
    t_ave_corr=imagesToTempNT_PD(angle(average_corr),directory);
    out.t_ave_corr=t_ave_corr;
    out.pd_ave_corr=average_corr;
end

%% display images
if getHOTReconOption('display')
    figure
    for echo_num=1:size(out.im,3)/2
        subplot(ceil((size(out.im,3)/2)/4),4,echo_num)
        imagesc(abs(squeeze(out.im(1,1,zq_windows(echo_num),:,:))));
        axis image off
    end
end
% rows=[65 80 100];
% figure,subplot(3,2,1)
% imagesc(abs(squeeze(t(1,1,1,:,:))));
% axis image off
% line([1 128],[rows(2) rows(2)],'color','k','LineWidth',2);
% subplot(3,2,2);
% plot(squeeze(t(1,1,1,rows(2),49:92))');
% title('T profile - 1^s^t echo','FontSize',18);
% axis square
% subplot(3,2,3);
% imagesc(abs(squeeze(t(1,1,2,:,:))));
% axis image off
% line([1 128],[rows(2) rows(2)],'color','k','LineWidth',2);
% subplot(3,2,4);
% plot(squeeze(t(1,1,2,rows(2),49:92))');
% title('T profile - 2^n^d echo','FontSize',18);
% axis square
% subplot(3,2,5);
% imagesc(abs(squeeze(t(1,1,3,:,:))));
% axis image off
% line([1 128],[rows(2) rows(2)],'color','k','LineWidth',2);
% subplot(3,2,6);
% plot(squeeze(t(1,1,3,rows(2),49:92))');
% title('T profile - 3^r^d echo','FontSize',18);
% axis square
% s=strfind(directory,'\');
% set(gcf,'Name',strcat('Scan',directory(s(end)+1:end)));
