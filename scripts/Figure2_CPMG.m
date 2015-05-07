rf=zeros(1,40000);
gauss=@(s,x)exp(-x.^2/(sqrt(2)*s^2));
echo_period=1400;
rf_off=0.6;

% make figure for writing text
figure
set(gcf,'Position',[520 493 492 305]);
set(gca,'Xlim',[0 40000]);
set(gca,'Ylim',[-0.5 1.5]);
hold on

% excitation
rf(1000)=0.5;
centeredTextOnPlot(1000,0.6,'90\circ_x');


% refocusing
rf(19500)=1;
centeredTextOnPlot(19500,1.1,'180\circ_\theta');

% echo
rf(36001:40000)=gauss(800,-2000:1999).*cos(2*pi*(-2000:1999)/echo_period)*0.5;
centeredTextOnPlot(38000,0.6,'ACQ');

plot(rf,'k','LineWidth',2);
axis square off
set(findobj(gca,'Type','text'),'FontName','Arial');
set(findobj(gca,'Type','text'),'FontSize',18);

print(gcf,'C:\Users\Ryan2\Documents\My manuscripts and conference abstracts\warren lab manuscripts\Multi-echo HOT encoding\figures\CPMG pulse sequence diagram\CPMG psd','-dpng','-r300');