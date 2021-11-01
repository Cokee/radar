clc,clear,close all
B = 10e6;
Tp = 1e-6;
a = 1;
k = B/Tp/2;
fs = [20e6 40e6 40e7];       %采样频率
Ts = 1./fs;
n = Tp*fs;
t = linspace(-Tp/2,Tp/2,n(3)+1);
t1 = linspace(-Tp/2,Tp/2,n(1)+1);
t2 = linspace(-Tp/2,Tp/2,n(2)+1);
x1 = a*exp(1i*2*pi*k.*t1.^2);
x2 = a*exp(1i*2*pi*k.*t2.^2);
x3 = a*exp(1i*2*pi*k.*t.^2);

figure(1);
subplot(2,1,1);
plot(t,real(x3),'b','LineWidth',1);
xlabel('t/s');
title('实部分量');
grid on;
subplot(2,1,2);
plot(t,imag(x3),'r','LineWidth',1);
title('虚部分量');
xlabel('t/s')
grid on;

x1_fft = fft(x1)*2/(n(1)+1);
x1_f = fftshift(x1_fft);
f1 = linspace(-fs(1)/2,fs(1)/2,n(1)+1);

x2_fft = fft(x2)*2/(n(2)+1);
x2_f = fftshift(x2_fft);
f2 = linspace(-fs(2)/2,fs(2)/2,n(2)+1);

figure(2);
plot(f1,abs(x1_f),'b','LineWidth',1);
xlabel('f/Hz');
grid on;
hold on;
plot(f2,abs(x2_f),'r','LineWidth',1);
title('不同采样率下的频谱');
legend('fs=10MHz','fs=20MHz');
xlabel('f/Hz');
grid on;

%% 回波加窗
r_x1 = awgn(x1,20); %加高斯白噪声
r_x2 = awgn(x2,20); 

win1 = 1.852*hamming(n(1)+1);
win_x1 = r_x1.*win1';   %加窗
win_x1_fft = fft(win_x1)*2/(n(1)+1);
win_x1_f = fftshift(win_x1_fft);

figure(3);
subplot(2,1,1);
plot(f1,abs(fftshift(fft(r_x1)*2/(n(1)+1))),'b','LineWidth',1);
grid on;
hold on;
plot(f1,abs(win_x1_f),'r','LineWidth',1);
title('fs=10MHz');
legend('未加窗的回波信号','加窗后的回波信号')
xlabel('f/Hz');
grid on;

win2 = 1.852*hamming(n(2)+1);
win_x2 = r_x2.*win2';
win_x2_fft = fft(win_x2)*2/n(2);
win_x2_f = fftshift(win_x2_fft);

subplot(2,1,2);
plot(f2,abs(fftshift(fft(r_x2)*2/n(2))),'b','LineWidth',1);
grid on;
hold on;
plot(f2,abs(win_x2_f),'r','LineWidth',1);
grid on;
title('fs=20MHz');
legend('未加窗的回波信号','加窗后的回波信号')
xlabel('f/Hz');

%% 匹配滤波
h1 = conj(x1(end:-1:1));
y1 = conv(win_x1,h1,"same");
figure; 
plot(t1,abs(y1),'b','LineWidth',1);
hold on;
h2 = conj(x2(end:-1:1));
y2 = conv(win_x2,h2,"same");
plot(t2,abs(y2),'r','LineWidth',1);
title('匹配滤波器输出');
grid on;
legend('fs=10MHz','fs=20MHz');
xlabel('t/s');
