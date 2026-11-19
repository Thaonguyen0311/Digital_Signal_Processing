% Exercise 2: Two frequency components and single-sided FFT amplitude
clear; close all; clc;
fs = 200;
T = 1;
t = 0:1/fs:T-1/fs;
x = 0.8*sin(2*pi*15*t) + 0.4*sin(2*pi*40*t);
figure('Color','w','Position',[100 100 900 650]);
tiledlayout(2,1,'TileSpacing','compact');
nexttile; plot(t,x,'LineWidth',1.1); grid on;
xlabel('Time (s)'); ylabel('Amplitude'); title('Time-domain signal');
N = length(x); Y = fft(x);
P2 = abs(Y/N); P1 = P2(1:N/2+1); P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:N/2)/N;
nexttile; stem(f,P1,'filled','MarkerSize',3); grid on; xlim([0 fs/2]);
xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('Single-sided amplitude spectrum');
exportgraphics(gcf,fullfile(fileparts(mfilename('fullpath')),'two-frequency-spectrum.png'),'Resolution',180);
fprintf('N = %d, bin spacing = %.2f Hz\n',N,fs/N);
