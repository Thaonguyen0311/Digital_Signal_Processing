%% Lecture 6: Practical Digital Filtering
% Reproducible FIR/IIR sensor comparison and 50 Hz audio hum reduction.
% Requires Signal Processing Toolbox (fir1, butter, filtfilt, freqz).
clear; close all; clc;
scriptDir = fileparts(mfilename('fullpath'));
figDir = fullfile(scriptDir,'figures');
if ~exist(figDir,'dir'), mkdir(figDir); end

fprintf('MATLAB version: %s\n',version);
if license('test','Signal_Toolbox')
    fprintf('Signal Processing Toolbox: available\n');
else
    fprintf('Signal Processing Toolbox: unavailable\n');
end

%% Part A: Sensor signal
Fs = 1000;
t = (0:1/Fs:2-1/Fs)';
rng(7,'twister');
clean = sin(2*pi*5*t) + 0.35*sin(2*pi*12*t);
noise = 0.35*sin(2*pi*50*t) + 0.20*sin(2*pi*137*t) + 0.25*randn(size(t));
x = clean + noise;

fc = 20;
bFIR = fir1(60,fc/(Fs/2),'low');       % 60th order, 61 taps
[bIIR,aIIR] = butter(4,fc/(Fs/2),'low'); % 4th order Butterworth
% filtfilt applies the filter forward and backward for zero-phase offline output.
yFIR = filtfilt(bFIR,1,x);
yIIR = filtfilt(bIIR,aIIR,x);

rmseNoisy = sqrt(mean((x-clean).^2));
rmseFIR = sqrt(mean((yFIR-clean).^2));
rmseIIR = sqrt(mean((yIIR-clean).^2));
rmseTable = table([rmseNoisy;rmseFIR;rmseIIR], ...
    'RowNames',{'Noisy input','FIR output','IIR output'}, ...
    'VariableNames',{'RMSE'});
disp('Part A RMSE against the known clean signal:');
disp(rmseTable);

%% Figure 1: Sensor time comparison on a 0.2 second interval
short = t <= 0.2;
fig = figure('Color','w','Name','Sensor time comparison');
plot(t(short),clean(short),'k--','LineWidth',1.3); hold on;
plot(t(short),x(short),'Color',[0.70 0.70 0.70],'LineWidth',0.8);
plot(t(short),yFIR(short),'b','LineWidth',1.1);
plot(t(short),yIIR(short),'r','LineWidth',1.1);
grid on; xlabel('Time (s)'); ylabel('Amplitude');
title('Sensor signal: clean, noisy, FIR and IIR outputs');
legend('Clean reference','Noisy input','FIR output','IIR output','Location','best');
exportgraphics(fig,fullfile(figDir,'sensor-time-comparison.png'),'Resolution',180);

%% Figure 2: FIR and IIR magnitude responses
[HFIR,fResp] = freqz(bFIR,1,8192,Fs);
[HIIR,~] = freqz(bIIR,aIIR,8192,Fs);
fig = figure('Color','w','Name','Sensor filter responses');
plot(fResp,20*log10(max(abs(HFIR),1e-10)),'b','LineWidth',1.2); hold on;
plot(fResp,20*log10(max(abs(HIIR),1e-10)),'r','LineWidth',1.2);
xline(fc,'k--','20 Hz cutoff','LabelVerticalAlignment','bottom');
grid on; xlim([0 200]); ylim([-120 5]);
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
title('Magnitude responses of the sensor low-pass filters');
legend('FIR order 60 (61 taps)','Butterworth IIR order 4','Location','southwest');
exportgraphics(fig,fullfile(figDir,'sensor-filter-responses.png'),'Resolution',180);

%% Figure 3: Sensor spectra and RMSE evidence
[fX,AX] = singleSidedAmplitude(x,Fs);
[~,AFIR] = singleSidedAmplitude(yFIR,Fs);
[~,AIIR] = singleSidedAmplitude(yIIR,Fs);
fig = figure('Color','w','Name','Sensor spectra and RMSE');
tiledlayout(2,1,'TileSpacing','compact');
nexttile;
plot(fX,AX,'Color',[0.65 0.65 0.65],'LineWidth',0.8); hold on;
plot(fX,AFIR,'b','LineWidth',1.0);
plot(fX,AIIR,'r','LineWidth',1.0);
xlim([0 200]); grid on; xlabel('Frequency (Hz)'); ylabel('Single-sided amplitude');
title('Noisy input and filtered output spectra');
legend('Noisy input','FIR output','IIR output','Location','northeast');
nexttile; axis off;
text(0.05,0.83,sprintf('RMSE against clean reference (lower is better)\nNoisy input: %.4f\nFIR output: %.4f\nIIR output: %.4f', ...
    rmseNoisy,rmseFIR,rmseIIR),'Units','normalized','FontSize',12,'VerticalAlignment','top');
text(0.55,0.83,'Expected spectral behavior','Units','normalized','FontSize',12,'FontWeight','bold','VerticalAlignment','top');
text(0.55,0.62,'5 Hz and 12 Hz: wanted components should remain.\n50 Hz and 137 Hz: interference should be attenuated.', ...
    'Units','normalized','FontSize',11,'VerticalAlignment','top');
exportgraphics(fig,fullfile(figDir,'sensor-spectra-rmse.png'),'Resolution',180);

%% Part B: Add and reduce 50 Hz hum in the built-in Handel example
handelData = load('handel'); % MATLAB example supplies y and Fs
xClean = handelData.y(:);
FsAudio = handelData.Fs;
if FsAudio <= 102
    error('The audio sample rate must exceed 102 Hz to represent a 50 Hz tone.');
end
tAudio = (0:numel(xClean)-1)'/FsAudio;
xHum = xClean + 0.15*sin(2*pi*50*tAudio);

[bNotch,aNotch] = butter(2,[49 51]/(FsAudio/2),'stop');
[bWide,aWide] = butter(2,[45 55]/(FsAudio/2),'stop');
yNarrow = filtfilt(bNotch,aNotch,xHum);
yWide = filtfilt(bWide,aWide,xHum);

% Report attenuation at 50 Hz directly from each filter's frequency response.
H50Narrow = freqz(bNotch,aNotch,2*pi*50/FsAudio);
H50Wide = freqz(bWide,aWide,2*pi*50/FsAudio);
attenNarrow50dB = 20*log10(max(abs(H50Narrow),realmin));
attenWide50dB = 20*log10(max(abs(H50Wide),realmin));
fprintf('Audio sample rate: %g Hz; duration: %.2f s\n',FsAudio,numel(xClean)/FsAudio);
fprintf('50 Hz response attenuation: narrow [49,51] Hz = %.2f dB; wide [45,55] Hz = %.2f dB\n', ...
    attenNarrow50dB,attenWide50dB);

%% Figure 4: Audio waveform comparison, first 0.25 seconds
shortAudio = tAudio <= 0.25;
fig = figure('Color','w','Name','Audio waveform comparison');
plot(tAudio(shortAudio),xClean(shortAudio),'k','LineWidth',0.9); hold on;
plot(tAudio(shortAudio),xHum(shortAudio),'Color',[0.7 0.7 0.7],'LineWidth',0.8);
plot(tAudio(shortAudio),yNarrow(shortAudio),'b','LineWidth',1.0);
plot(tAudio(shortAudio),yWide(shortAudio),'Color',[0.1 0.55 0.2],'LineWidth',1.0);
grid on; xlabel('Time (s)'); ylabel('Amplitude');
title('Handel audio: clean, hum-added and filtered');
legend('Clean reference','Added 50 Hz hum','Narrow stop band 49-51 Hz','Wide stop band 45-55 Hz','Location','best');
exportgraphics(fig,fullfile(figDir,'audio-waveform-comparison.png'),'Resolution',180);

%% Figure 5: Audio spectra around the hum and low audio frequencies
[fClean,AClean] = singleSidedAmplitude(xClean,FsAudio);
[~,AHum] = singleSidedAmplitude(xHum,FsAudio);
[~,ANarrow] = singleSidedAmplitude(yNarrow,FsAudio);
[~,AWide] = singleSidedAmplitude(yWide,FsAudio);
fig = figure('Color','w','Name','Audio spectra');
plot(fClean,AClean,'k','LineWidth',0.8); hold on;
plot(fClean,AHum,'Color',[0.7 0.7 0.7],'LineWidth',0.8);
plot(fClean,ANarrow,'b','LineWidth',1.0);
plot(fClean,AWide,'Color',[0.1 0.55 0.2],'LineWidth',1.0);
xlim([0 250]); grid on; xlabel('Frequency (Hz)'); ylabel('Single-sided amplitude');
xline(50,'r--','50 Hz hum');
title('Handel audio spectra before and after hum reduction');
legend('Clean reference','Hum-added','Narrow stop band','Wide stop band','Location','best');
exportgraphics(fig,fullfile(figDir,'audio-spectra.png'),'Resolution',180);

%% Figure 6: Optional notch response for the two stop-band widths
[HN,fN] = freqz(bNotch,aNotch,8192,FsAudio);
[HW,~] = freqz(bWide,aWide,8192,FsAudio);
fig = figure('Color','w','Name','Audio notch responses');
plot(fN,20*log10(max(abs(HN),1e-10)),'b','LineWidth',1.2); hold on;
plot(fN,20*log10(max(abs(HW),1e-10)),'Color',[0.1 0.55 0.2],'LineWidth',1.2);
xline(50,'k--','50 Hz'); grid on; xlim([0 120]); ylim([-120 5]);
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
title('Narrow and wide Butterworth stop-band responses');
legend('Stop band 49-51 Hz','Stop band 45-55 Hz','Location','southwest');
exportgraphics(fig,fullfile(figDir,'audio-notch-responses.png'),'Resolution',180);

%% Optional same-gain listening comparison
% Set this to true in MATLAB to listen to both versions at the same gain.
% The script does not write any audio files.
playAudio = false;
if playAudio
    commonPeak = max(abs([xHum; yNarrow]));
    sound(xHum/commonPeak,FsAudio); pause(numel(xHum)/FsAudio + 1);
    sound(yNarrow/commonPeak,FsAudio);
end

fprintf('Figures saved in: %s\n',figDir);

function [f,P1] = singleSidedAmplitude(signal,Fs)
    signal = signal(:);
    N = length(signal);
    Y = fft(signal);
    P2 = abs(Y/N);
    P1 = P2(1:floor(N/2)+1);
    if rem(N,2)==0
        P1(2:end-1) = 2*P1(2:end-1);
    else
        P1(2:end) = 2*P1(2:end);
    end
    f = Fs*(0:floor(N/2))/N;
end

