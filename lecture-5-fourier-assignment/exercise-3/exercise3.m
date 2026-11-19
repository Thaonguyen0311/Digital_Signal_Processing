% Exercise 3: Spectral leakage, longer duration, and zero-padding
clear; close all; clc;
fs = 200;
d = 4; % Replace with the last digit of your student number (0 to 9)
f2 = 13.2 + 0.17*d;
T1 = 1; t1 = 0:1/fs:T1-1/fs;
x1 = 0.8*sin(2*pi*15*t1) + 0.4*sin(2*pi*f2*t1);
T4 = 4; t4 = 0:1/fs:T4-1/fs;
x4 = 0.8*sin(2*pi*15*t4) + 0.4*sin(2*pi*f2*t4);
figure('Color','w','Position',[100 100 1100 800]);
tiledlayout(3,1,'TileSpacing','compact');
% One-second record
N1 = length(x1); Y1 = fft(x1); P21 = abs(Y1/N1); P11 = P21(1:N1/2+1); P11(2:end-1)=2*P11(2:end-1); f1=fs*(0:N1/2)/N1;
nexttile; plot(f1,P11,'LineWidth',1); grid on; xlim([8 20]); ylabel('Amplitude'); title(sprintf('1 second: bin spacing %.2f Hz',fs/N1));
% Four-second record
N4 = length(x4); Y4 = fft(x4); P24 = abs(Y4/N4); P14 = P24(1:N4/2+1); P14(2:end-1)=2*P14(2:end-1); f4=fs*(0:N4/2)/N4;
nexttile; plot(f4,P14,'LineWidth',1); grid on; xlim([8 20]); ylabel('Amplitude'); title(sprintf('4 seconds: bin spacing %.2f Hz',fs/N4));
% Zero-pad one-second record to four times its length
Npad = 4*N1; Ypad = fft(x1,Npad); P2pad=abs(Ypad/N1); P1pad=P2pad(1:Npad/2+1); P1pad(2:end-1)=2*P1pad(2:end-1); fpad=fs*(0:Npad/2)/Npad;
nexttile; plot(fpad,P1pad,'LineWidth',1); grid on; xlim([8 20]); xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('1 second record zero-padded to 4N (display interpolation)');
sgtitle(sprintf('Leakage around f_2 = %.2f Hz (d = %d)',f2,d));
exportgraphics(gcf,fullfile(fileparts(mfilename('fullpath')),'leakage-comparison.png'),'Resolution',180);
fprintf('d = %d, f2 = %.2f Hz; bin spacings: %.2f Hz (1 s), %.2f Hz (4 s), %.2f Hz (zero-padded grid)\n',d,f2,fs/N1,fs/N4,fs/Npad);
