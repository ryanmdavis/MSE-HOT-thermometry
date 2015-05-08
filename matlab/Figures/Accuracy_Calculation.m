RMD276;
RMD277;
RMD278;
RMD279;
RMD280;
RMD281;

rmsd    =[rmsd_RMD276 rmsd_RMD277 rmsd_RMD278 rmsd_RMD279 rmsd_RMD280 rmsd_RMD281];
rmsd_rel=[rmsd_rel_RMD276 rmsd_rel_RMD277 rmsd_rel_RMD278 rmsd_rel_RMD279 rmsd_rel_RMD280 rmsd_rel_RMD281];

% mean and std of absolute rmsd
mean(rmsd)
std(rmsd)

% mean and std of relative rmsd
mean(rmsd_rel)
std(rmsd_rel)