% Exercise 4: DTFT curve and DFT samples
clear; close all; clc;
x = [1 1 1 1];
n = 0:length(x)-1;
w = linspace(-pi,pi,1000);
Xdtft = x * exp(-1j*(n.'*w));
X4 = fft(x,4); X64 = fft(x,64);
w4 = 2*pi*(0:3)/4; w64 = 2*pi*(0:63)/64;
% Map DFT frequencies from [0,2pi) to [-pi,pi) for comparison
w4 = mod(w4+pi,2*pi)-pi; w64 = mod(w64+pi,2*pi)-pi;
figure('Color','w','Position',[100 100 900 550]);
plot(w,abs(Xdtft),'LineWidth',1.5,'DisplayName','DTFT'); hold on;
stem(w4,abs(X4),'filled','DisplayName','4-point DFT');
stem(w64,abs(X64),'Marker','none','DisplayName','64-point DFT');
grid on; xlim([-pi pi]); xlabel('Angular frequency (rad/sample)'); ylabel('Magnitude');
title('DTFT curve and DFT samples for x = [1 1 1 1]'); legend('Location','best');
exportgraphics(gcf,fullfile(fileparts(mfilename('fullpath')),'dtft-dft-comparison.png'),'Resolution',180);
