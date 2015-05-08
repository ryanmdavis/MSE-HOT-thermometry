reconstruct('RMD275',30,'num_echoes');
[mse2_zq_windows,mse2_sq_windows] = zqsqCoherenceOrder(20);
pt=[71 56];
plot_echoes=1:16;

% plot it
errorbar(plot_echoes,angle(mean(RMD275_Sc30_HOT.im(:,1,mse2_zq_windows(plot_echoes),pt(1),pt(2)))),std(angle(RMD275_Sc30_HOT.im(:,1,mse2_zq_windows(plot_echoes),pt(1),pt(2))),[],1),'kx')
hold on
errorbar(plot_echoes,angle(mean(RMD275_Sc30_HOT.im(:,1,mse2_sq_windows(plot_echoes),pt(1),pt(2)))),std(angle(RMD275_Sc30_HOT.im(:,1,mse2_sq_windows(plot_echoes),pt(1),pt(2))),[],1),'bo')
errorbar(plot_echoes,angle(mean(RMD275_Sc30_HOT.pd(:,1,(plot_echoes),pt(1),pt(2)))),std(angle(RMD275_Sc30_HOT.pd(:,1,(plot_echoes),pt(1),pt(2)))),'r*','MarkerSize',10);
plot(plot_echoes,squeeze(angle(mean(RMD275_Sc30_HOT.im(:,1,mse2_zq_windows(plot_echoes),pt(1),pt(2))))),'k')
plot(plot_echoes,squeeze(angle(mean(RMD275_Sc30_HOT.im(:,1,mse2_sq_windows(plot_echoes),pt(1),pt(2))))),'b')
plot(plot_echoes,squeeze(angle(mean(RMD275_Sc30_HOT.pd(:,1,(plot_echoes),pt(1),pt(2))))),'r');
xlim([1 16]);
ylim([-2.5 5])
axis square
xlabel('echo number','FontSize',fs);
ylabel('echo phase (rad)','FontSize',fs);
set(gca,'FontSize',fs-3);
legend('iZQC','SQC','corr.');