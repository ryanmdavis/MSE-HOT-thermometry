% returns the file location of various data needed for reconstruction of
% HOT data.
function path=hotPath(type)

parent_dir='C:\Users\Aspect\Dropbox\MSE-HOT thermometry';
switch type
    case 'images'
        % path type: cell array of directories.  the function getDirScanInfo
        % searches these directories for image data.  You can add multiple
        % directories here by adding another string entry to the cell.
        % e.g."
        % path = {'C:/xxx'
        %         'C:/yyy'
        %         'C:/zzz'}
        path={strcat(parent_dir,'\Bruker data')};
    case 'luxtron'
        % path type: directory of luxtron (fiberoptic thermometer) data
        path=strcat(parent_dir,'\Luxtron data');
    case 'calibration'
        % path type: file
        % contents: 
        %   nu_of_T: linear mapping of iZQC frequency (nu) to temperature
        %       (T)
        %   T_of_nu: linear mapping of temperature to iZQC frequency
        %   S_of_TE: the average complex signal of fat-water iZQC in red
        %       marrow.  Used for weighted averaging of echoes
        path=strcat(parent_dir,'\calibration\hot calibration curves.mat');
    case 'options'
        % path type: file
        % contents: various options for reconstructing HOT data.  Type
        % HOTReconOptions in command line for GUI
        path=strcat(parent_dir,'\recon options\HOTReconOptions.mat');
    otherwise
        error('path must be either "data", "luxtron" or "calibration"');
end 