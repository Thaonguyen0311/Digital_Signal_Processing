%% MATLAB Assignment: Z-Transform and Sample Delays
% Run this script from MATLAB. It creates the requested plots in the
% outputs folder and prints the output samples for both filter settings.

clear; clc; close all;

outDir = fileparts(mfilename('fullpath'));

%% Part 1: Signal and one-sample delay
x = [1 2 1];
n = 0:length(x)-1;

% A one-sample delay inserts a zero at n = 0.
xDelayed = [0 x];
nDelayed = 0:length(xDelayed)-1;

fig1 = figure('Name', 'Original and delayed signals', 'Color', 'w');
subplot(2,1,1);
stem(n, x, 'filled');
title('Original Signal x[n]');
xlabel('Sample n'); ylabel('Amplitude'); grid on;
subplot(2,1,2);
stem(nDelayed, xDelayed, 'filled');
title('One-Sample Delay x[n-1]');
xlabel('Sample n'); ylabel('Amplitude'); grid on;
saveas(fig1, fullfile(outDir, 'original_and_delayed.png'));

%% Part 2: Average current and previous input
% Append a zero so the response to the final listed input sample is shown.
xInput = [x 0];
nOutput = 0:length(xInput)-1;
a = 1;

% Original system H(z) = 0.5 + 0.5z^(-1)
b = [0.5 0.5];
y = filter(b, a, xInput);

fig2 = figure('Name', 'Output for H(z) = 0.5 + 0.5z^{-1}', 'Color', 'w');
subplot(2,1,1);
stem(nOutput, xInput, 'filled');
title('Input x[n]'); xlabel('Sample n'); ylabel('Amplitude'); grid on;
subplot(2,1,2);
stem(nOutput, y, 'filled');
title('Output y[n] for b = [0.5 0.5]');
xlabel('Sample n'); ylabel('Amplitude'); grid on;
saveas(fig2, fullfile(outDir, 'output_original_filter.png'));

disp('Output samples for H(z) = 0.5 + 0.5z^(-1):');
disp(y);

%% Change to H(z) = 0.8 + 0.2z^(-1)
b = [0.8 0.2];
yChanged = filter(b, a, xInput);

fig3 = figure('Name', 'Output for H(z) = 0.8 + 0.2z^{-1}', 'Color', 'w');
subplot(2,1,1);
stem(nOutput, xInput, 'filled');
title('Input x[n]'); xlabel('Sample n'); ylabel('Amplitude'); grid on;
subplot(2,1,2);
stem(nOutput, yChanged, 'filled');
title('Output y[n] for b = [0.8 0.2]');
xlabel('Sample n'); ylabel('Amplitude'); grid on;
saveas(fig3, fullfile(outDir, 'output_changed_filter.png'));

disp('Output samples for H(z) = 0.8 + 0.2z^(-1):');
disp(yChanged);

