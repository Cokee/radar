clc,clear,close all
Tp = 1e-6;
f0 = 2e9;
fs = 8e9;
R0 = 1e3;
v = 10;
c = 3e8;
tmax = 2*(2*R0+c*Tp)/(c+2*v);
t = [0:1/fs:tmax];          %仿真时间范围
n = length(t);
x_a = zeros(1,n);
x_a(1:Tp*fs) = 1;
x = x_a.*exp(1j*2*pi*f0.*t);%发射信号
figure;
plot(t/1e6,real(x),'b');
hold on;
ylim([-2.5 2.5]);
y_a = zeros(1,n);
y_a(fs*2*R0/(c+2*v):fs*(2*R0+c*Tp)/(c+2*v)) = 0.5;
y =  y_a.*exp(1j*2*pi*f0*(1+2*v/c).*t);  %接收回波信号
y = awgn(y,30);
plot(t/1e6,real(y),'r');
legend('发射脉冲信号','接收脉冲回波信号')
xlabel('时间/us');
grid on;
x_f = fftshift(fft(x))*2/n;
y_f = fftshift(fft(y))*2/n;
f = (-n/2:n/2-1)*fs/n;
figure;
subplot(2,1,1);
plot(f*1e-9,abs(x_f),'b');
xlabel('频率/GHz');
grid on;
xlim([1.5 2.5]);
ylim([0,0.15]);
title('发射脉冲信号');
subplot(2,1,2);
plot(f*1e-9,abs(y_f),'r');
xlabel('频率/GHz');
xlim([1.5 2.5]);
ylim([0,0.15]);
grid on;
title('接收脉冲回波信号');