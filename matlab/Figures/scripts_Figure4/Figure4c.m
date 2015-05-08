mse2_phase_vs_t_curve
sli_iZQC_phase_vs_t

p_mse=anova1(phase_all_mse(4:9,:),[],'off');
p_sli=anova1(phase_all_sli,[],'off');

errorbar(TE_mse,mean(phase_all_mse,2),std(phase_all_mse,0,2),'bo');
hold on
errorbar(TE_sli,mean(phase_all_sli,1),std(phase_all_sli,0,1),'kx','MarkerSize',15);
xlabel('Echo Time (ms)','FontSize',fs);
ylabel('iZQC phase (rad)','FontSize',fs);
axis square
set(gca,'FontSize',fs-3);
legend('MSE','SSE');