% Lecture 02: Sampling and Aliasing Investigation
% Generates the continuous-time reference plot and five sampling plots.
clear; close all; clc;

f0 = 10;                 % signal frequency, Hz
T = 1;                   % duration, seconds
dt = 1e-4;               % fine time step for the visual reference
t = 0:dt:T;
x = sin(2*pi*f0*t);

figure('Color','w');
plot(t,x,'b','LineWidth',1.5); grid on;
xlabel('Time (s)'); ylabel('Amplitude');
title('10 Hz Sine Wave — Continuous-Time Reference');
legend('Original signal','Location','best');
xlim([0 T]); ylim([-1.2 1.2]);
exportgraphics(gcf,'original_signal.png','Resolution',150);

sampling_frequencies = [15 20 25 50 100];
figure('Color','w','Position',[100 100 1000 1000]);
tiledlayout(5,1,'TileSpacing','compact','Padding','compact');
for k = 1:numel(sampling_frequencies)
    fs = sampling_frequencies(k);
    ts = 0:1/fs:T;
    xs = sin(2*pi*f0*ts);
    nexttile;
    plot(t,x,'b-','LineWidth',1.1); hold on;
    stem(ts,xs,'r','filled','LineWidth',1.0,'MarkerSize',4);
    grid on; xlim([0 T]); ylim([-1.2 1.2]);
    ylabel('Amplitude');
    title(sprintf('Sampling at %d Hz',fs));
    if k == 1
        legend('10 Hz reference','Samples','Location','eastoutside');
    end
    if k == numel(sampling_frequencies), xlabel('Time (s)'); end
end
exportgraphics(gcf,'sampling_comparison.png','Resolution',150);

% Save the five individually requested sampling figures as well.
for k = 1:numel(sampling_frequencies)
    fs = sampling_frequencies(k);
    ts = 0:1/fs:T;
    xs = sin(2*pi*f0*ts);
    figure('Color','w');
    plot(t,x,'b-','LineWidth',1.4); hold on;
    stem(ts,xs,'r','filled','LineWidth',1.1,'MarkerSize',5);
    grid on; xlim([0 T]); ylim([-1.2 1.2]);
    xlabel('Time (s)'); ylabel('Amplitude');
    title(sprintf('10 Hz Signal Sampled at %d Hz',fs));
    legend('Original 10 Hz signal','Samples','Location','best');
    exportgraphics(gcf,sprintf('sampling_%dHz.png',fs),'Resolution',150);
    close(gcf);
end
