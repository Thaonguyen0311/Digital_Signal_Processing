%% Lecture 6: Practical Digital Filtering
% Reproducible FIR/IIR sensor comparison and 50 Hz audio hum reduction.
% Uses base-MATLAB design and forward-backward filtering helpers, so the
% experiment can run when Signal Processing Toolbox is not installed.
clear; close all; clc;
scriptDir = fileparts(mfilename('fullpath'));
figDir = fullfile(scriptDir,'figures');
if ~exist(figDir,'dir'), mkdir(figDir); end

fprintf('MATLAB version: %s\n',version);
hasSignalToolbox = license('test','Signal_Toolbox');
hasSignalToolbox = hasSignalToolbox && exist('fir1','file') == 2 && ...
    exist('butter','file') == 2 && exist('filtfilt','file') == 2 && exist('freqz','file') == 2;
fprintf('Signal Processing Toolbox functions available: %d\n',hasSignalToolbox);

%% Part A: Sensor signal
Fs = 1000;
t = (0:1/Fs:2-1/Fs)';
rng(7,'twister');
clean = sin(2*pi*5*t) + 0.35*sin(2*pi*12*t);
noise = 0.35*sin(2*pi*50*t) + 0.20*sin(2*pi*137*t) + 0.25*randn(size(t));
x = clean + noise;

fc = 20;
if hasSignalToolbox
    bFIR = fir1(60,fc/(Fs/2),'low');
    [bIIR,aIIR] = butter(4,fc/(Fs/2),'low');
    yFIR = filtfilt(bFIR,1,x);
    yIIR = filtfilt(bIIR,aIIR,x);
else
    % Toolbox-free equivalents: Hamming FIR, bilinear Butterworth, and
    % reflected-padding forward-backward filtering.
    bFIR = designWindowedLowpass(60,fc,Fs);
    [bIIR,aIIR] = designButterworthLowpass(4,fc,Fs);
    yFIR = zeroPhaseFilter(bFIR,1,x,3*(max(numel(bFIR),1)-1));
    yIIR = zeroPhaseFilter(bIIR,aIIR,x,3*(max(numel(bIIR),numel(aIIR))-1));
end

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
if hasSignalToolbox
    [HFIR,fResp] = freqz(bFIR,1,8192,Fs);
    [HIIR,~] = freqz(bIIR,aIIR,8192,Fs);
else
    [HFIR,fResp] = baseFrequencyResponse(bFIR,1,8192,Fs);
    [HIIR,~] = baseFrequencyResponse(bIIR,aIIR,8192,Fs);
end
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

if hasSignalToolbox
    [bNotch,aNotch] = butter(2,[49 51]/(FsAudio/2),'stop');
    [bWide,aWide] = butter(2,[45 55]/(FsAudio/2),'stop');
    yNarrow = filtfilt(bNotch,aNotch,xHum);
    yWide = filtfilt(bWide,aWide,xHum);
else
    [bNotch,aNotch] = designButterworthBandstop(2,[49 51],FsAudio);
    [bWide,aWide] = designButterworthBandstop(2,[45 55],FsAudio);
    % Longer reflected padding lets the narrow notch settle near record edges.
    padNarrow = min(numel(xHum)-1,max(3*(max(numel(bNotch),numel(aNotch))-1),ceil(6*FsAudio/2)));
    padWide = min(numel(xHum)-1,max(3*(max(numel(bWide),numel(aWide))-1),ceil(6*FsAudio/10)));
    yNarrow = zeroPhaseFilter(bNotch,aNotch,xHum,padNarrow);
    yWide = zeroPhaseFilter(bWide,aWide,xHum,padWide);
end

% Report attenuation at 50 Hz directly from each filter's frequency response.
if hasSignalToolbox
    H50Narrow = freqz(bNotch,aNotch,2*pi*50/FsAudio);
    H50Wide = freqz(bWide,aWide,2*pi*50/FsAudio);
else
    H50Narrow = baseFrequencyAt(bNotch,aNotch,50,FsAudio);
    H50Wide = baseFrequencyAt(bWide,aWide,50,FsAudio);
end
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
if hasSignalToolbox
    [HN,fN] = freqz(bNotch,aNotch,8192,FsAudio);
    [HW,~] = freqz(bWide,aWide,8192,FsAudio);
else
    [HN,fN] = baseFrequencyResponse(bNotch,aNotch,8192,FsAudio);
    [HW,~] = baseFrequencyResponse(bWide,aWide,8192,FsAudio);
end
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

function b = designWindowedLowpass(order,fc,Fs)
    % Hamming-windowed ideal low-pass, normalized to unity gain at DC.
    if fc <= 0 || fc >= Fs/2 || order < 1 || rem(order,2) ~= 0
        error('Use an even FIR order and a cutoff between 0 and Fs/2.');
    end
    n = 0:order;
    center = order/2;
    normalizedCutoff = fc/(Fs/2);
    q = normalizedCutoff*(n-center);
    sincValues = ones(size(q));
    nz = q ~= 0;
    sincValues(nz) = sin(pi*q(nz))./(pi*q(nz));
    ideal = normalizedCutoff*sincValues;
    window = 0.54 - 0.46*cos(2*pi*n/order);
    b = ideal.*window;
    b = b/sum(b);
end

function [b,a] = designButterworthLowpass(order,fc,Fs)
    % Analog Butterworth poles, prewarped bilinear transform, zeros at z=-1.
    if fc <= 0 || fc >= Fs/2 || order < 1
        error('Cutoff must be between 0 and Fs/2, and order must be positive.');
    end
    cutoffAnalog = 2*Fs*tan(pi*fc/Fs);
    k = 1:order;
    prototypePoles = exp(1j*pi*(2*k+order-1)/(2*order));
    analogPoles = cutoffAnalog*prototypePoles;
    digitalPoles = (2*Fs+analogPoles)./(2*Fs-analogPoles);
    a = real(poly(digitalPoles));
    b0 = real(poly(-ones(1,order)));
    b = b0*(sum(a)/sum(b0));
end

function [b,a] = designButterworthBandstop(order,edgesHz,Fs)
    % Butterworth low-pass prototype transformed to an analog band-stop,
    % then bilinear transformed to the digital domain.
    f1 = edgesHz(1); f2 = edgesHz(2);
    if f1 <= 0 || f2 <= f1 || f2 >= Fs/2
        error('Stop-band edges must satisfy 0 < f1 < f2 < Fs/2.');
    end
    omega1 = 2*Fs*tan(pi*f1/Fs);
    omega2 = 2*Fs*tan(pi*f2/Fs);
    bandwidth = omega2-omega1;
    center = sqrt(omega1*omega2);
    k = 1:order;
    prototypePoles = exp(1j*pi*(2*k+order-1)/(2*order));
    analogPoles = zeros(1,2*order);
    at = 1;
    for p = prototypePoles
        rootTerm = sqrt(bandwidth^2-4*p^2*center^2);
        analogPoles(at:at+1) = [(bandwidth+rootTerm)/(2*p), ...
                                 (bandwidth-rootTerm)/(2*p)];
        at = at+2;
    end
    digitalPoles = (2*Fs+analogPoles)./(2*Fs-analogPoles);
    digitalZero = (2*Fs+1j*center)/(2*Fs-1j*center);
    digitalZeros = [repmat(digitalZero,1,order),repmat(conj(digitalZero),1,order)];
    a = real(poly(digitalPoles));
    b0 = real(poly(digitalZeros));
    b = b0*(sum(a)/sum(b0)); % unity gain at DC
end

function [H,f] = baseFrequencyResponse(b,a,nPoints,Fs)
    % Base-MATLAB equivalent of freqz for a uniform 0-to-Nyquist grid.
    omega = linspace(0,pi,nPoints).';
    numerator = exp(-1j*omega*(0:numel(b)-1))*b(:);
    denominator = exp(-1j*omega*(0:numel(a)-1))*a(:);
    H = numerator./denominator;
    f = omega*Fs/(2*pi);
end

function H = baseFrequencyAt(b,a,fHz,Fs)
    omega = 2*pi*fHz/Fs;
    numerator = sum(b(:).'.*exp(-1j*omega*(0:numel(b)-1)));
    denominator = sum(a(:).'.*exp(-1j*omega*(0:numel(a)-1)));
    H = numerator/denominator;
end

function y = zeroPhaseFilter(b,a,x,padLength)
    % Reflect-pad, filter forward, reverse, filter again, and crop.
    % This base-MATLAB helper has filtfilt-style zero-phase behavior; its
    % edge handling is approximate and should be checked for the application.
    x = x(:);
    n = numel(x);
    padLength = min(max(0,round(padLength)),n-1);
    if padLength == 0
        extended = x;
    else
        pre = 2*x(1)-x((padLength+1):-1:2);
        post = 2*x(end)-x((end-1):-1:(end-padLength));
        extended = [pre;x;post];
    end
    y = filter(b,a,extended);
    y = flipud(y);
    y = filter(b,a,y);
    y = flipud(y);
    y = y(padLength+1:padLength+n);
end

