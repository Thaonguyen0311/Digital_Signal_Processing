%% Lecture 01 - Signal Visualization
% Simple signal generation and visualization
% Author: ThaoNguyen
% Date: 17.09

clear;
clc;
close all;

%% Common time vector
fs = 1000;              % Sampling frequency (Hz)
t = 0:1/fs:1;           % Duration = 1 second

%% Task 1 - Create a Sine Wave
A = 1;                  % Amplitude
f = 5;                  % Frequency (Hz)

signal = A * sin(2*pi*f*t);

figure;
plot(t, signal, 'LineWidth', 1.5);
title('5 Hz Sine Wave');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

%% Task 2 - Compare Different Frequencies
frequencies = [2, 5, 10];

figure;

for i = 1:length(frequencies)
    f = frequencies(i);
    signal = sin(2*pi*f*t);

    subplot(3,1,i);
    plot(t, signal, 'LineWidth', 1.2);
    title([num2str(f) ' Hz Sine Wave']);
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;
end

sgtitle('Frequency Comparison');

% Save figure
saveas(gcf, 'frequency_comparison.png');


%% Task 3 - Compare Different Amplitudes
amplitudes = [0.5, 1, 2];
f = 5;                  % Same frequency for all signals

figure;

for i = 1:length(amplitudes)
    A = amplitudes(i);
    signal = A * sin(2*pi*f*t);

    subplot(3,1,i);
    plot(t, signal, 'LineWidth', 1.2);
    title(['Amplitude = ' num2str(A)]);
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;
end

sgtitle('Amplitude Comparison');

% Save figure
saveas(gcf, 'amplitude_comparison.png');


%% Task 4 - Add Noise
A = 1;
f = 5;

clean_signal = A * sin(2*pi*f*t);

% Generate random noise
noise = 0.3 * randn(size(t));

% Add noise to clean signal
noisy_signal = clean_signal + noise;

figure;

subplot(2,1,1);
plot(t, clean_signal, 'LineWidth', 1.2);
title('Clean Sine Wave');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(2,1,2);
plot(t, noisy_signal, 'LineWidth', 1.0);
title('Noisy Sine Wave');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

sgtitle('Clean vs. Noisy Signal');

% Save figure
saveas(gcf, 'clean_vs_noisy_signal.png');


%% End of script
disp('All tasks completed successfully.');