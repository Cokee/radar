clc,clear,close all
a = 1; 
f0 = 2e6;
phi = pi/2;
fs = 10e6;
Ts = 1/fs;          % 采样周期
ts(1) = 50e-6;      % 采样时间1
ts(2) = 50.1e-6;    % 采样时间2
n = fs*ts;          % 采样点数

% 采样
for i=1:n(1)
    s1(i) = a*cos(2*pi*f0*(i-1)*Ts+phi);
end
for i=1:n(2)
    s2(i) = a*cos(2*pi*f0*(i-1)*Ts+phi);
end

%% 第一问
% fft变换
s1_fft = fft(s1)*2/n(1);
s1_f = fftshift(s1_fft);

s2_fft = fft(s2)*2/n(2);
s2_f = fftshift(s2_fft);

f1 = (-n(1)/2:n(1)/2-1)*(fs/n(1));
f2 = (-n(2)/2:n(2)/2-1)*(fs/n(2));      % 频率轴刻度

figure;
plot(f1,abs(s1_f));
hold on;
plot(f2,abs(s2_f),'r');
title(['fs = ' num2str(fs*1e-6) 'MHz']);
xlabel('频率/Hz');
legend('50us','50.1us');
grid on;

%% 第二问
% 希尔伯特变换
for i=1:n(1)
    s1i(i) = a*sin(2*pi*f0*(i-1)*Ts+phi);
end

y = s1+1i*s1i;      %复信号

% fft变换
y_fft = fft(y)*2/n(1);
y_f = fftshift(y_fft);

figure;
subplot(2,1,1);
plot(f1,abs(s1_f));
title('实信号频谱');
grid on;
hold on;
subplot(2,1,2);
plot(f1,abs(y_f));
title('复信号频谱');
xlabel('频率/Hz');
grid on;

%% 第三问
win = hamming(n(2));
win_s2 = s2.*win';
win_s2_fft = fft(win_s2)*2/n(2);
win_s2_f = fftshift(win_s2_fft);

figure;
plot(f1,abs(s1_f),'g','LineWidth',1);
hold on;
plot(f2,abs(s2_f),'blue','LineWidth',1);
hold on;
plot(f2,1.852*abs(win_s2_f),'red','LineWidth',1);
xlim([0 5e6])
ylim([0 1])
xlabel('频率/Hz');
legend('无频谱泄露','有频谱泄露','加窗后')
grid on;
