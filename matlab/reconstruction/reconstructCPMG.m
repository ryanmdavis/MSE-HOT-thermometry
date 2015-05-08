function [spects,peak_height]=reconstructCPMG(directory,varargin)

[~,~,spects]=reconstructBruker1DseriesC(directory);
fids=zeros(size(spects,1),2^13);
fids(:,1:size(spects,2))=ifft(fftshift(spects,2),[],2);
% fids=fids(:,50:end);
spects=fftshift(fft(fids,[],2),2);
p_method = struct('num_offset',[],'num_power',[],'num_pulse_min',[],'num_pulse_max',[],'power_list',[],'offset_list',[],'RefPulse',[],'PVM_SpecSWH',[],'PVM_SpecSW',[]);
p_method = getPVEntry3([directory '\method'],p_method);

RefPulse=parsePulseInfo(p_method.RefPulse);

% integ_factor_locs=strfind(p_method.RefPulse,',');
% integ_factor_start=integ_factor_locs(10)+2;
% integ_factor_end=integ_factor_locs(11)-1;
% integ_factor=str2num(p_method.RefPulse(integ_factor_start:integ_factor_end));

b1_nominal=(1000*RefPulse.Length)*(360/RefPulse.FlipAngle)*(RefPulse.IntegralRatio);
b1=b1_nominal*10.^((RefPulse.Attenuation-p_method.power_list)/20);

num_offset=p_method.num_offset;
num_power=p_method.num_power;
num_pulse=p_method.num_pulse_max-p_method.num_pulse_min+1;
spect_size=size(spects,2);

% if we are cycling through different power or offset values
if (~isempty(num_power)&&(~isempty(num_offset)))&&((num_power>1)||(num_offset>1))
    % spects=reshape(spects,1,size(spects,2)*num_power*num_offset*num_pulse);
    spects=reshape(permute(spects,[2 1]),spect_size,num_power,num_offset,num_pulse);

    m=squeeze(max(abs(spects),[],1));

    fs=18;
    figure,imagesc(m');
    axis square
    xlabel('offset (Hz)','FontSize',fs)
    ylabel('B_1 (Hz)','FontSize',fs);
    set(gca,'FontSize',fs);
    
    if num_offset==1
        xtick=1;
    else
        xtick=round(get(gca,'XTick'));
    end
    set(gca,'XTickLabel',round(p_method.offset_list(xtick)));
    if num_power==1
        ytick=1;
    else
        ytick=get(gca,'YTick');
    end
    set(gca,'YTickLabel',roundn(b1(ytick),2));
    
    title(RefPulse.Filename,'FontSize',18);
else %if we are varying the number of refocusing pulses
%     fid=ifft(fftshift(spects,2),[],2);
    if nargin==3 %if a integration range is specified
        int_range_ppm=varargin{1};
        center_ppm=varargin{2};
        int_range_ppm_this_scale=int_range_ppm-center_ppm;
        ppm=linspace(-0.5*p_method.PVM_SpecSW,0.5*p_method.PVM_SpecSW,size(spects,2));
        int_bins_=findClosestTimeSamples(ppm,int_range_ppm_this_scale);
        int_bins=int_bins_(1):int_bins_(2);
    else %integrate the 60Hz around the maximum peak
        [m,i_max]=max(abs(spects),[],2);
        m=m/min(m);
        int_range_bin=round(size(spects,2)*60/p_method.PVM_SpecSWH/2); %integrate over 60 Hz
        int_bins=(i_max-int_range_bin):(i_max+int_range_bin);
    end
    m_int=zeros(1,size(spects,1));
    for spect_num=1:size(spects,1)
       m_int(spect_num)=sum(abs(spects(spect_num,int_bins)));
    end
    m_int=m_int/m_int(1);
%     figure,plot(p_method.num_pulse_min:p_method.num_pulse_max,m_int,'k');
%     hold on
%     scatter(p_method.num_pulse_min:p_method.num_pulse_max,m_int,'ko','SizeData',120);
%     xlabel('number of rfc pulses');
%     ylabel('normalized signal');
%     ylim([min(m_int)-0.1 max(m_int)+0.1]);
%     axis square
%     niceFigure(gcf);
end
peak_height=m_int;