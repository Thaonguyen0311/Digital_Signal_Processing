% Lecture 02 In-Class: Hearing and Seeing Aliasing
% Downsamples a 7 kHz tone without anti-alias filtering and saves four spectra.
clear; close all; clc;

fs_original = 48000;
signal_frequency = 7000;
duration = 2;
amplitude = 0.20;
t = 0:1/fs_original:duration-1/fs_original;
x = amplitude * sin(2*pi*signal_frequency*t);
sampling_rates = [24000 16000 12000 8000];

% Listen at a low computer/headphone volume. Uncomment playback lines if needed.
disp('Original signal: 7 kHz');
% soundsc(x, fs_original); pause(duration + 1);

for k = 1:numel(sampling_rates)
    fs_low = sampling_rates(k);
    M = fs_original / fs_low;
    if mod(M,1) ~= 0
        error('Choose an fs_low value that divides 48000 exactly.');
    end
    x_alias = x(1:M:end);       % Deliberately no anti-aliasing filter
    nyquist_frequency = fs_low/2;

    % One-sided periodogram in kHz, so plotted axes and titles are consistent.
    [Pxx,f] = periodogram(x_alias,[],[],fs_low);
    figure('Color','white');
    plot(f/1000,10*log10(max(Pxx,realmin)),'LineWidth',1.3);
    hold on;
    observed_peak = abs(mod(signal_frequency + fs_low/2, fs_low) - fs_low/2);
    xline(observed_peak/1000,'--r',sprintf('Peak: %.0f kHz',observed_peak/1000), ...
        'LineWidth',1.5,'LabelVerticalAlignment','bottom');
    xlim([0 fs_low/2000]);
    xlabel('Frequency (kHz)'); ylabel('Power/Frequency (dB/Hz)');
    title(sprintf('7 kHz Tone After Downsampling: f_s = %d kHz',fs_low/1000));
    grid on;
    exportgraphics(gcf,sprintf('spectrum_%dkHz.png',fs_low/1000),'Resolution',150);

    fprintf('Sampling frequency: %g kHz | Nyquist: %g kHz | Peak: %g kHz | Aliasing: %s\n', ...
        fs_low/1000,nyquist_frequency/1000,observed_peak/1000, ...
        string(signal_frequency > nyquist_frequency));
    disp(sprintf('Downsampled tone at %g kHz',observed_peak/1000));
    % Uncomment to listen after confirming your volume is low:
    % soundsc(x_alias, fs_low); pause(duration + 1);
end
