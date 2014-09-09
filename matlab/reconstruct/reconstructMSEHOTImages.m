function out=reconstructMSEHOTImages(directory)

sq_ref_image = 1;

p_m = struct('num_echoes',[],'t1',[],'tau_min',[],'time_bw_rfc_pulses',[],'TE_ms',[]);
p_m = getPVEntry3([directory '\method'],p_m);
[zq_windows,sq_windows] = zqsqCoherenceOrder(p_m.num_echoes);


[~,k] = reconstructHOT2DSLI(directory);
k=flipdim(k,4);
[max_row,max_col] = maxRowColIndex(squeeze(k(1,1,2,:,:)));
f_surf_norm = reshape(makeFermiSurface([size(k,4) size(k,5)],[5 5],[1 1],[max_row max_col]),1,1,1,size(k,4),size(k,5));
k=circshift(k,[0 0 0 floor(-max_row+1+size(k,4)/2) -max_col+1+size(k,5)/2]);
for timepoint = 1:size(k,1);
    for delay_num=1:size(k,2);
        for zq_echo_num=1:size(zq_windows,2) 
            k(timepoint,delay_num,zq_windows(zq_echo_num),:,:) = k(timepoint,delay_num,zq_windows(zq_echo_num),:,:).*f_surf_norm;
            k(timepoint,delay_num,sq_windows(zq_echo_num),:,:) = k(timepoint,delay_num,sq_windows(zq_echo_num),:,:).*f_surf_norm;
        end
    end
end

%% phase the iZQC images to the closest SQC echo
%the following correctly phases alternating echoes in the image domain
im=fftshift(fftshift(ifft(ifft(fftshift(fftshift(k,4),5),[],4),[],5),4),5);
im=upsampleImage(im,4);
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
[t_ave]=imagesToTempNT_PD(angle(average),directory);

out=struct('im',im,'k',k,'t',t,'nu',nu,'pd',pd,'t_ave',t_ave);

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
