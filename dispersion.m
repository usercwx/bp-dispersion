%% 实验表面波相速度频散曲线计算
clc
clear all
%仿真参数
Fs = 2.5e9;
t = 0:4e-10:5e-6;
a1 = 100;
a2 = 2e7; 
a3 = 6e13; 
a4 = 3e5;
s = 4;
t0 = 0;
SNR = 100; %信噪比
r = 30/1000; %信号间距
% VelocityRange = [2000 8000 1]; %估计的速度范围
% lilun=a1*(((t-t0).*exp((-(a2.*(t-t0)).^2)./(2.*s.^2)))./s.^2).*sin(2.*pi.*10e6.*t+2.*pi.*(a3.*t).*t);
% lilun2=[zeros(1,0.5e-6/4e-10) lilun];
% saw2=awgn(lilun2,SNR,'measured');%添加高斯白噪声
% B=saw2/max(abs(saw2));%归一化
lilun1 = a1*(((t-t0).*exp((-(a2.*(t-t0)).^2)./(2.*s.^2)))./s.^2).*sin(2.*pi.*10e6.*t+2.*pi.*(a3.*t).*t);
M=zeros(3,100);

for i=0:99
k=-4e-8*i;
lilun2 = Artificial_disp(lilun1,r,Fs,k);
% lilun3 = Artificial_disp(lilun2,r,Fs);
% lilun4 = Artificial_disp(lilun3,r,Fs);
% lilun5 = Artificial_disp(lilun4,r,Fs);
% lilun6 = Artificial_disp(lilun5,r,Fs);
% lilun7 = Artificial_disp(lilun6,r,Fs);
% lilun8 = Artificial_disp(lilun7,r,Fs);
% lilun9 = Artificial_disp(lilun8,r,Fs);
% lilun10 = Artificial_disp(lilun9,r,Fs);
% U0 = [lilun1',lilun2',lilun3',lilun4',lilun5',lilun6',lilun7',lilun8',lilun9',lilun10',];
saw1=awgn(lilun1,SNR,'measured');%添加高斯白噪声
saw2=awgn(lilun2,SNR,'measured');%添加高斯白噪声
A=saw1/max(abs(saw1));%归一化
B=saw2/max(abs(saw2));%归一化
[pks_B,locs_B]=findpeaks(B,'MinPeakHeight',1e-3);%寻找峰值点
sum_p=length(pks_B);%峰值数量
[high_B,p]=max(pks_B);
M(1,i+1)=locs_B(p);%统计最高峰出现位置
M(2,i+1)=sum_p;%统计峰值数量
M(3,i+1)=abs(k);%斜率

end

pea0=mapminmax(M,0,1);
pea1=pea0(1:2,:);
pea=pea1+0.00.*rand(2,100);
peak=[pea;pea0(3,:)];
%% 绘图
figure (1)
plot(t*1e6,A./max(A),'black','LineWidth',1.0)
hold on
plot(t*1e6,B./max(B),'red','LineWidth',1.0)
legend('original signal','Post signal');
xlabel('Time \itt \rm(µs)');
ylabel('Amplitude');
axis([0 5 -1.1 1.2])
set(gca,'FontSize',12,'Fontname','Arial')
set(gcf,'position',[800,300,500,220])