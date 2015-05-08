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

function out = getDirScanInfo_HOTMSE_ZQSQ3(directory)

%% read in data about image
[~,kspace,~,~] = reconstructHOT2DSLI(directory);
frequency_data=0; %#ok<NASGU>

%% figure out what kind of data set this is (image, spect, etc.)
if size(kspace,4)>1
    out = getDirScanInfo_HOTMSE_ZQSQ3_img(directory,kspace);
else size(kspace,2)>1
   out = getDirScanInfo_HOTMSE_ZQSQ3_spect(directory,kspace); 
end

    