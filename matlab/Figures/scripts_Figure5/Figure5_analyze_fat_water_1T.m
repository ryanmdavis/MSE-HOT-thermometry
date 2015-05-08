data_dir='C:\Users\Aspect\Documents\ryan\CPMG - fat\07032014\';
zf_factor=8;
ppm_int_range=[0.6 1.7];

%% water data
water1=load('C:\Users\Ryan2\Documents\My manuscripts and conference abstracts\warren lab manuscripts\Multi-echo HOT encoding\figures\simulations and CPMG\1T data\water.mat');
max_peak = zeros(1,size(water1.data,2));
zf_spectra=zeros(size(water1.data,2),zf_factor*size(water1.data(1).spectrum,2));
for exp_num=1:size(water1.data,2)
    this_fid = water1.data(exp_num).fid;
    this_fid_zero_fill=zeros(1,zf_factor*size(water1.data(1).spectrum,2));
    this_fid_zero_fill(1:size(water1.data(1).spectrum,2))=this_fid;
    this_spectrum=fftshift(fft(fftshift(this_fid_zero_fill)));
    zf_spectra(exp_num,:)=this_spectrum;
    max_peak(exp_num)=max(abs(this_spectrum));
end
normalized_1T_water_exp=max_peak/max_peak(1);

%% oleic data
oleic=load('C:\Users\Ryan2\Documents\My manuscripts and conference abstracts\warren lab manuscripts\Multi-echo HOT encoding\figures\simulations and CPMG\1T data\oleic1.mat');
max_peak = zeros(1,size(oleic.data,2));
zf_spectra=zeros(size(oleic.data,2),zf_factor*size(oleic.data(1).spectrum,2));
for exp_num=1:size(oleic.data,2)
    this_fid = oleic.data(exp_num).fid;
    this_fid_zero_fill=zeros(1,zf_factor*size(oleic.data(1).spectrum,2));
    this_fid_zero_fill(1:size(oleic.data(1).spectrum,2))=this_fid;
    this_spectrum=fftshift(fft(fftshift(this_fid_zero_fill)));
    zf_spectra(exp_num,:)=this_spectrum;
    [~,i_max]=max(abs(this_spectrum));
    max_peak(exp_num)=sum(abs(this_spectrum(i_max-8:i_max+8)));
end
normalized_1T_oleic_exp=max_peak/max_peak(end);

%% palmitic data
palmitic=load('C:\Users\Ryan2\Documents\My manuscripts and conference abstracts\warren lab manuscripts\Multi-echo HOT encoding\figures\simulations and CPMG\1T data\palmitic3.mat');
max_peak = zeros(1,size(palmitic.data,2));
zf_spectra=zeros(size(palmitic.data,2),zf_factor*size(palmitic.data(1).spectrum,2));
for exp_num=1:size(palmitic.data,2)
    this_fid = palmitic.data(exp_num).fid;
    this_fid_zero_fill=zeros(1,zf_factor*size(palmitic.data(1).spectrum,2));
    this_fid_zero_fill(1:size(palmitic.data(1).spectrum,2))=this_fid;
    this_spectrum=fftshift(fft(fftshift(this_fid_zero_fill)));
    zf_spectra(exp_num,:)=this_spectrum;
    [~,i_max]=max(abs(this_spectrum));
    max_peak(exp_num)=sum(abs(this_spectrum(i_max-8:i_max+8)));
end
normalized_1T_palmitic_exp=max_peak/max_peak(end);

%% cholesteryl data
cholesteryl=load('C:\Users\Ryan2\Documents\My manuscripts and conference abstracts\warren lab manuscripts\Multi-echo HOT encoding\figures\simulations and CPMG\1T data\cholesteryl benzoate2.mat');
max_peak = zeros(1,size(cholesteryl.data,2));
zf_spectra=zeros(size(cholesteryl.data,2),zf_factor*size(cholesteryl.data(1).spectrum,2));
for exp_num=1:size(cholesteryl.data,2)
    this_fid = cholesteryl.data(exp_num).fid;
    this_fid_zero_fill=zeros(1,zf_factor*size(cholesteryl.data(1).spectrum,2));
    this_fid_zero_fill(1:size(cholesteryl.data(1).spectrum,2))=this_fid;
    this_spectrum=fftshift(fft(fftshift(this_fid_zero_fill)));
    zf_spectra(exp_num,:)=this_spectrum;
    [~,max_bin]=max(abs(this_spectrum));
    max_peak(exp_num)=abs(this_spectrum(max_bin));
end
normalized_1T_cholesteryl_exp=max_peak/max_peak(end);
