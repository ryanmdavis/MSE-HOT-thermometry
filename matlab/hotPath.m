% returns the file location of various data needed for reconstruction of
% HOT data.
function path=hotPath(type)

parent_dir='C:\Users\Ryan2\Documents\My manuscripts and conference abstracts\warren lab manuscripts\Multi-echo HOT encoding\MSE-HOT-thermometry\';
if ~strcmp(parent_dir(end),'\'), parent_dir=strcat(parent_dir,'\'); end
switch type
    case 'images'
        % path type: cell array of directories.  the function getDirScanInfo
        % searches these directories for image data
        path={strcat(parent_dir,'Bruker data')};
    case 'luxtron'
        % path type: directory of luxtron (fiberoptic thermometer) data
        path=strcat(parent_dir,'Luxtron data');
    case 'calibration'
        % path type: file
        % contents: 
        %   nu_of_T: linear mapping of iZQC frequency (nu) to temperature
        %       (T)
        %   T_of_nu: linear mapping of temperature to iZQC frequency
        %   S_of_TE: the average complex signal of fat-water iZQC in red
        %       marrow.  Used for weighted averaging of echoes
        path=strcat(parent_dir,'calibration\hot calibration curves.mat');
    case 'roi'
        path=strcat(parent_dir,'ROIs');
    case 'options'
        path=strcat(parent_dir,'recon options\HOTReconOptions.mat');
    case 'sim'
        path=strcat(parent_dir,'simulation results\');
    otherwise
        error('path must be either "images", "luxtron", "options", "roi", "sim" or "calibration"');
end 