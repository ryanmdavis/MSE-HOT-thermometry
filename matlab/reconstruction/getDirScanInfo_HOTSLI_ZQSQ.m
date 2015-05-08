%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  This function calls reconstructHOT2DSLI, which reconstructs the raw 
%  Bruker fid file into a 5D matrix = (repetitions, t1 delay, echo number,
%  phase encode step, read encode step).  The large if/elseif structure
%  (line 14) just formats or displays the data differently based on if the data is an
%  image, 2D spectrum, chemical shift image, etc...  The if statement
%  determines the type of experiment (spectrum/image) based on the size of
%  the kspace data returned from reconstructHOT2DSLI.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [im,kspace,temperature_data,frequency_data] = getDirScanInfo_HOTSLI_ZQSQ(directory)
recon_mat_size = 1024;
[im,kspace,hz1,hz2] = reconstructHOT2DSLI(directory);
p_m = struct('Exp_type',[],'t1',[],'tau_min',[],'tau_max',[],'num_echoes',[],'num_echoes_SQ',[]);
p_m = getPVEntry3([directory '\method'],p_m);
frequency_data=0;
if size(kspace,2) > 4 && size(kspace,3) == 2 && size(kspace,4) == 1 %i.e. if I am trying to make an 2 window iMQC spectrum
    kspace = permute(squeeze(kspace),[2 1 3]);
    kspace(:,:,1) = 0;
    im = flipdim(flipdim(fftshift(fftshift(fft(fft(kspace,recon_mat_size,2),recon_mat_size,3),2),3),2),3);
    bw_f1 = max(hz1) - min(hz1);
    bw_f2 = max(hz2) - min(hz2);
    t_f1 = 0:(1/bw_f1):(size(kspace,2)/bw_f1);
    t_f2 = 0:(1/bw_f2):(size(kspace,3)/bw_f2);
    exp_name = findExpName(directory);
    displayHot2DSpectraB(im,bw_f1,0,4000,bw_f2,0,4000);
    set(gcf,'Name',exp_name);
    displayHot2DFidsB(abs(kspace),max(t_f1)*1000,mean(t_f1)*1000,max(t_f1)*1000,max(t_f2)*1000,mean(t_f2)*1000,max(t_f2)*1000);
    subplot(1,2,1);
    title('abs - iZQC','FontSize',15);
    subplot(1,2,2);
    title('abs - SQC','FontSize',15);
    set(gcf,'Name',exp_name);
    temperature_data = 0;
elseif size(kspace,2) > 4 && size(kspace,3) == 1
    kspace = squeeze(kspace);
    im = flipdim(flipdim(fftshift(fftn(kspace,[recon_mat_size recon_mat_size])),2),3);
    bw_f1 = max(hz1) - min(hz1);
    bw_f2 = max(hz2) - min(hz2);
    t_f1 = 0:(1/bw_f1):(size(kspace,1)/bw_f1);
    t_f2 = 0:(1/bw_f2):(size(kspace,2)/bw_f2);
    figure,subplot(1,2,1);
    display2DSpectrumB(im,bw_f1,0,4000,bw_f2,0,4000);
    set(gcf,'Name',strcat('images - ',directory));
    subplot(1,2,2);
    display2DFidsB(real(kspace),max(t_f1)*1000,mean(t_f1)*1000,max(t_f1)*1000,max(t_f2)*1000,mean(t_f2)*1000,max(t_f2)*1000);
    set(gcf,'Name',strcat('fids - ',directory));
    temperature_data = 0;
elseif size(kspace,2) == 3  && size(kspace,3) <= 2
    temperature_data = calcTemp3DelayCycleHOTSLIc(directory,kspace,'add_pi',pi,'gaussian_filter',[3 3],'recon_size',64);
elseif size(kspace,3) <= 2 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%this condition executes if doing a single ZQSQ image, no CSI, no
    %%multi-echo encoding
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    kspace(:,:,1,:,1)=0;
    kspace(:,:,1,16,:)=0;
    kspace=flipdim(kspace,5);
    kspace=makeKSpaceMatSquare(kspace);
    [max_row,max_col] = maxRowColIndex(squeeze(kspace(1,1,2,:,:)));
    f_surf_norm = reshape(makeFermiSurface([size(kspace,4) size(kspace,5)],[5 5],[1 1],[max_row max_col]),1,1,1,size(kspace,4),size(kspace,5));
    for delay_number = 1:size(kspace,2)
        for time_point = 1:size(kspace,1)
            kspace(time_point,delay_number,1,:,:) = kspace(time_point,delay_number,1,:,:).*f_surf_norm;
        end
    end
    kspace(:,:,1,:,:)=kspace(:,:,1,:,:);
    im = fftshift(fftshift(fft(fft(ifftshift(ifftshift(kspace,4),5),[],4),[],5),4),5);
    im = upsampleImage(im,getHOTReconOption('recon_size')/size(kspace,5));
    [temperature_data,frequency_data] = imagesToTempNT(im,p_m.t1+p_m.tau_min,'dir',directory);
    
%     temperature_data=frequency_data;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if we are making a multi echo 2D spectrum:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif size(kspace,3) > 2 && size(kspace,4) == 1
    if strcmp(p_m.Exp_type,'HOT_2D_RARE_ZQSQ2 ')
       kspace = resortHOTRARE2windows(kspace);
    end
    num_echoes = p_m.num_echoes+p_m.num_echoes_SQ;
    %dimensions are rep,delay,window,phase,read
    kspace(:,:,:,:,1:2) = 0;
    kspace(abs(kspace) > 2^19) = 0;
    kspace_unpadded = permute(kspace,[1 4 3 2 5]);
    im = fftshift(fftshift(fft(fft(ifftshift(ifftshift(kspace_unpadded,4),5),[],4),[],5),4),5);
    bw_f1 = max(hz1) - min(hz1);
    bw_f2 = max(hz2) - min(hz2);
    t_f1 = 0:(1/bw_f1):(size(kspace_unpadded,4)/bw_f1);
    t_f2 = 0:(1/bw_f2):(size(kspace_unpadded,5)/bw_f2);
    hz_f1 = -0.5*bw_f1:bw_f1/(size(kspace,4)-1):0.5*bw_f1;
    hz_f2 = -0.5*bw_f2:bw_f1/(size(kspace,5)-1):0.5*bw_f2;
    f_s = figure;
    f_k = figure;

    for echo_num = 0:size(kspace,3)/2-1
        figure(f_s)
        subplot(4,round(num_echoes/4),echo_num+1)
        imagesc(abs(squeeze(im(1,1,echo_num+1,:,:))))
        title(strcat('echo ',num2str(echo_num+1),' - iZQC - abs'),'FontSize',15)
        set(gca,'FontSize',15);
        axis square off
        figure(f_k)
        subplot(4,round(num_echoes/4),echo_num+1)
        imagesc(imag(squeeze(kspace_unpadded(1,1,echo_num+1,:,:))));
        title(strcat('echo ',num2str(echo_num+1),' - iZQC - imag'),'FontSize',15)
        set(gca,'FontSize',15);
        axis square off
    end
    
    figure,plot(squeeze(max(max(abs(kspace(1,1,1:p_m.num_echoes,:,:)),[],4),[],5)));
    title('iZQC signal vs echo number');
    
    kspace = kspace_unpadded;
    temperature_data = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If this is a multi-echo image (RARE)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(p_m.Exp_type,'HOT_2D_RARE_ZQSQ ') || strcmp(p_m.Exp_type,'HOT_2D_RARE_ZQSQ2 ')
    
    %% if this is ZQSQ2 then put ZQ as the first N/2 windows and SQ as the
    %% second N/2 windows:
    if strcmp(p_m.Exp_type,'HOT_2D_RARE_ZQSQ2 ')
       kspace = resortHOTRARE2windows(kspace);
    end
    kspace=flipdim(kspace,5);
    kspace=makeKSpaceMatSquare(kspace);
    
    %% shift to laboratory frame
    [r1,c1]=maxRowColIndex(abs(squeeze(kspace(1,1,1,:,:))));
    [r2,c2]=maxRowColIndex(abs(squeeze(kspace(1,1,2,:,:))));
    angle1=angle(kspace(1,1,1,r1,c1));
    angle2=angle(kspace(1,1,1,r2,c2));
    angle_lab=mean([angle1 angle2]);
    kspace=kspace*exp(-1i*angle_lab);
    
    %% filter k-space data
    [max_row,max_col] = maxRowColIndex(squeeze(kspace(1,1,p_m.num_echoes+1,:,:)));
    f_surf_norm = reshape(makeFermiSurface([size(kspace,4) size(kspace,5)],[5 5],[1 1],[max_row max_col]),1,1,1,size(kspace,4),size(kspace,5));
    for delay_number = 1:size(kspace,2)
        for time_point = 1:size(kspace,1)
            for echo_number = 1:p_m.num_echoes
                kspace(time_point,delay_number,echo_number,:,:) = kspace(time_point,delay_number,echo_number,:,:).*f_surf_norm;
            end
        end
    end

    im = fftshift(fftshift(fft(fft(ifftshift(ifftshift(kspace,4),5),[],4),[],5),4),5);
    im=upsampleImage(im,4);
    pd = zeros(size(im,1),size(im,2),size(im,3)/2,size(im,4),size(im,5));
    
    %% make phase corrections
    for timepoint = 1:size(im,1)
        for delay_num=1:size(im,2)
            for zq_echo_num=1:p_m.num_echoes
                if mod(zq_echo_num,2) %is odd?
                    pd(timepoint,delay_num,zq_echo_num,:,:) = im(timepoint,delay_num,zq_echo_num,:,:).*conj(im(timepoint,delay_num,p_m.num_echoes+1,:,:));%*exp(1i*pi/2);
                else
                    pd(timepoint,delay_num,zq_echo_num,:,:) = conj(im(timepoint,delay_num,zq_echo_num,:,:).*conj(im(timepoint,delay_num,p_m.num_echoes+1,:,:)));%*exp(-1i*pi/2));
                end
            end
        end
    end
    [temperature_data,frequency_data]=imagesToTempNT_PD(angle(pd),directory);

% % display image and k-space:
%     f_i = figure;
%     f_k = figure;
% 
%     for echo_num = 0:p_m.num_echoes-1
%         figure(f_i);
%         subplot(4,4,echo_num+1)
%         imagesc(abs(squeeze(im(1,1,echo_num+1,:,:))));%,[0  15]);
%         title(strcat('echo ',num2str(echo_num+1),' - iZQC'),'FontSize',15)
%         set(gca,'FontSize',15);
%         axis square off
%         figure(f_k);
%         subplot(4,4,echo_num+1)
%         imagesc(abs(squeeze(kspace(1,1,echo_num+1,:,:))));%,[0 max_iZQC_k]);
%         title(strcat('echo ',num2str(echo_num+1),' - iZQC'),'FontSize',15)
%         set(gca,'FontSize',15);
%         axis square off
%     end

end


function exp_name = findExpName(directory)
    ii = strfind(directory,'RMD');
    
    exp_name = directory(ii:end);
    