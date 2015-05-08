function out=reconstructMSEHOT(directory)

p_m = struct('phase_mat_size',[]);
p_m = getPVEntry3([directory '\method'],p_m);

if p_m.phase_mat_size==1 %if these are 2D spectra
    out=reconstructMSEHOTSpectra(directory);
else %any other condition: images or CSI
    out=reconstructMSEHOTImages(directory);
end