%% line sizes
bold=2.5;
thin=1;

%% space between channels
separation=2.3;
rf_off=1.5;
echo_off=0.9;
gz_off=rf_off-1*separation;
gx_off=rf_off-2*separation;
gy_off=rf_off-3*separation;

rf=zeros(65000,1);
gz=zeros(65000,1);
gx=zeros(65000,1);
gy=zeros(65000,9);

gz_crush=zeros(65000,1);
gx_crush=zeros(65000,2);
gy_crush=zeros(65000,2);
gz_crush2=zeros(65000,1);
gx_crush2=zeros(65000,2);
gy_crush2=zeros(65000,2);

shift=3000;
gauss=@(s,x)exp(-x.^2/(sqrt(2)*s^2));

echo_period=800;

figure
set(gca,'Xlim',[0 65000]);
set(gca,'Ylim',[-8 1.5]);
hold on
%hard excitation pulse
rf((1001:2000)+shift)=1;
centeredTextOnPlot(1501+shift,rf_off,'90^\circ');

%first correlation gradient
gz((2801:4200)+shift)=trap(1400,300);
centeredTextOnPlot(3001+shift,gz_off,'mGT');

%selective 180
rf((5001:8000)+shift)=gauss(600,-1500:1499);
centeredTextOnPlot(6501+shift,rf_off,'180^\circ_f');

%second correlation gradient
gz((8801:10200)+shift)=trap(1400,300);
centeredTextOnPlot(9500+shift,gz_off,'nGT');

%selective 90
rf((11001:14000)+shift)=gauss(600,-1500:1499);
centeredTextOnPlot(12501+shift,rf_off,'90^\circ_w');

%third correlation gradient
gz((14801:16200)+shift)=trap(1400,300);
centeredTextOnPlot(15501+shift+500,gz_off,'2mGT');

%slice selective sinc pulse
rf((22001:25000)+shift)=sinc((-1500:1499)*pi/2500);
centeredTextOnPlot(23501+shift,rf_off,'180^\circ');

%slice selection gradients
gz((21001:22000)+shift,1)=trap(1000,200);
gz((25001:26000)+shift,1)=trap(1000,200);
gz((21950:25050)+shift,1)=0.2;
gz_crush((21001:22000)+shift,1)=-trap(1000,200);
gz_crush((25001:26000)+shift,1)=-trap(1000,200);
gz_crush((22000:25001)+shift,1)=0.2;
gx_crush((21001:22000)+shift,1)=trap(1000,200);
gx_crush((21001:22000)+shift,2)=-trap(1000,200);
gx_crush((25001:26000)+shift,1)=trap(1000,200);
gx_crush((25001:26000)+shift,2)=-trap(1000,200);
gy_crush((21001:22000)+shift,1)=trap(1000,200);
gy_crush((21001:22000)+shift,2)=-trap(1000,200);
gy_crush((25001:26000)+shift,1)=trap(1000,200);
gy_crush((25001:26000)+shift,2)=-trap(1000,200);

%first echo
rf((27501:31500)+shift)=gauss(800,-2000:1999).*cos(2*pi*(-2000:1999)/echo_period)*0.5;
centeredTextOnPlot(29501+shift,echo_off,'iZQC');


%read encoding first echo
gx((26501:27500)+shift)=-trap(1000,200);
gx((31501:32500)+shift)=-trap(1000,200);
gx((27501:31500)+shift)=0.25*trap(4000,100);

%phase encoding first echo
for ii=4:-1:-4
    gy((26501:27500)+shift,5-ii)=trap(1000,200)*ii/4;
end
gy((31501:32500)+shift,:)=-gy((26501:27500)+shift,:);

%fourth correlation gradient
gz((32501:33900)+shift)=trap(1400,300);
centeredTextOnPlot(33501+shift,gz_off,'(m+n)GT');

%second echo
rf((35501:39500)+shift)=gauss(800,-2000:1999).*cos(2*pi*(-2000:1999)/echo_period)*0.5;
centeredTextOnPlot(37501+shift,echo_off,'SQC');

%read encoding second echo
gx((34501:35500)+shift)=-trap(1000,200);
gx((39501:40500)+shift)=-trap(1000,200);
gx((35501:39500)+shift)=0.25*trap(4000,100);

%phase encoding second echo
for ii=4:-1:-4
    gy((34501:35500)+shift,5-ii)=trap(1000,200)*ii/4;
end
gy((39501:40500)+shift,:)=-gy((34501:35500)+shift,:);

%2nd slice selective sinc pulse
rf((42001:45000)+shift)=sinc((-1500:1499)*pi/2500);

%2nd slice selection gradients
gz((41001:42000)+shift)=-trap(1000,200);
gz((45001:46000)+shift)=-trap(1000,200);
gz((41950:45050)+shift)=0.2;
gz_crush2((41001:42000)+shift,1)=trap(1000,200);
gz_crush2((45001:46000)+shift,1)=trap(1000,200);
gz_crush2((41950:45050)+shift,1)=0.2;
gx_crush2((41001:42000)+shift,1)=trap(1000,200);
gx_crush2((41001:42000)+shift,2)=-trap(1000,200);
gx_crush2((45001:46000)+shift,1)=trap(1000,200);
gx_crush2((45001:46000)+shift,2)=-trap(1000,200);
gy_crush2((41001:42000)+shift,1)=trap(1000,200);
gy_crush2((41001:42000)+shift,2)=-trap(1000,200);
gy_crush2((45001:46000)+shift,1)=trap(1000,200);
gy_crush2((45001:46000)+shift,2)=-trap(1000,200);

%third echo
rf((47501:51500)+shift)=gauss(800,-2000:1999).*cos(2*pi*(-2000:1999)/echo_period)*0.5;
centeredTextOnPlot(49501+shift,echo_off,'iZQC');

%read encoding third echo
gx((46501:47500)+shift)=-trap(1000,200);
gx((51501:52500)+shift)=-trap(1000,200);
gx((47501:51500)+shift)=0.25*trap(4000,100);

%phase encoding third echo
for ii=4:-1:-4
    gy((46501:47500)+shift,5-ii)=trap(1000,200)*ii/4;
end
gy((51501:52500)+shift,:)=-gy((46501:47500)+shift,:);

%fifth correlation gradient
gz((52501:53900)+shift)=trap(1400,300);

%fourth echo
rf((55501:59500)+shift)=gauss(800,-2000:1999).*cos(2*pi*(-2000:1999)/echo_period)*0.5;
centeredTextOnPlot(57501+shift,echo_off,'SQC');

%read encoding fourth echo
gx((54501:55500)+shift)=-trap(1000,200);
gx((59501:60500)+shift)=-trap(1000,200);
gx((55501:59500)+shift)=0.25*trap(4000,100);

%phase encoding fourth echo
for ii=4:-1:-4
    gy((54501:55500)+shift,5-ii)=trap(1000,200)*ii/4;
end
gy((59501:60500)+shift,:)=-gy((54501:55500)+shift,:);

%label channels
channel_offset=0.7;
text(0,channel_offset,'RF');
text(0,channel_offset-1*separation,'Gz');
text(0,channel_offset-2*separation,'Gx');
text(0,channel_offset-3*separation,'Gy');


gz=gz-separation;
gx=gx-2*separation;
gy=gy-3*separation;
gz_crush=gz_crush-1*separation;
gx_crush=gx_crush-2*separation;
gy_crush=gy_crush-3*separation;
gz_crush2=gz_crush2-1*separation;
gx_crush2=gx_crush2-2*separation;
gy_crush2=gy_crush2-3*separation;


plot(rf,'k','LineWidth',bold);
set(gcf,'Position',[213 226 1269 359]);
axis off
hold on
plot(gz(:,1),'k','LineWidth',bold);
plot(gx(:,1),'k','LineWidth',bold);
plot(gy(:,1),'k','LineWidth',bold);
plot(gy(:,2:end),'k','LineWidth',thin);
crush_range=21001:26000+shift;
crush_range2=44001:46000+shift;
plot(crush_range,gz_crush(crush_range,:),'k','LineWidth',thin);
plot(crush_range,gx_crush(crush_range,:),'k','LineWidth',thin);
% plot(crush_range,gy_crush(crush_range,:),'k','LineWidth',thin);
plot(crush_range2,gz_crush2(crush_range2,:),'k','LineWidth',thin);
plot(crush_range2,gx_crush2(crush_range2,:),'k','LineWidth',thin);
set(findobj(gca,'Type','text'),'FontName','Arial');
set(findobj(gca,'Type','text'),'FontSize',18);