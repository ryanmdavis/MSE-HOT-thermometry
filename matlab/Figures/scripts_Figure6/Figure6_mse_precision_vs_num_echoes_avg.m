mse_median_precision=zeros(1,16);
mse_mean_precision=zeros(1,16);
for num_echoes_avg=1:16
    setHOTReconOption('num_echoes_avg',num_echoes_avg);
    precision=Figure6_mse_sse_precision_compare(0);
    mse_median_precision(num_echoes_avg)=median(precision(:,1));
    mse_mean_precision(num_echoes_avg)=mean(precision(:,1));
end

fs=18;
f_echo_num=figure,scatter(1:16,mse_median_precision,'kx','SizeData',100,'LineWidth',2);
hold on
scatter(1:16,mse_mean_precision,'bo','LineWidth',2);
axis square
xlabel('# echoes averaged','FontSize',fs);
ylabel('precision (\circC)','FontSize',fs);
set(gca,'FontSize',15);
legend('median','mean');
xlim([1 16]);
ylim([0 2]);

