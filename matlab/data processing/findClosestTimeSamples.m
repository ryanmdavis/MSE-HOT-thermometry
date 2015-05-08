%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


% takes two arrays of time samples and returns the indecies for "finely
% sampled" that are closest to "coarsly sampled"
function bins=findClosestTimeSamples(finely_sampled,coarsely_sampled)
bins=zeros(size(coarsely_sampled));

for coarse_num=1:size(coarsely_sampled,2)
   diff=coarsely_sampled(coarse_num)-finely_sampled ;
   diff(diff<0)=inf;
   [~,closest_bin]=min(diff);
   bins(coarse_num)=closest_bin;
end