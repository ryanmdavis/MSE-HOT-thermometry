function setHOTReconOption(option,value)

% a list of valid options that can be set by this function:
valid_options={'num_echoes_avg','recon_size','data_type','display'};

% path to the .mat file that holds the recon options
recon_option_path='C:\Users\Ryan2\Documents\MATLAB\HOTReconOptions\HOTReconOptions.mat';

option_is_valid=0;
for option_num=1:size(valid_options,2)
    if strcmp(option,valid_options{option_num})
        option_is_valid=1;
        break
    end
end

if ~option_is_valid error(cell2str(strcat({'setHOTReconOption: '},{option},{' is not a valid option'}))); end
load(recon_option_path);
s.(option)=value;
save(recon_option_path,'s');