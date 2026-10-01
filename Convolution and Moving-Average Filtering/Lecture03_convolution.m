clear;
close all;
clc;

% Use the same random noise each time
rng(1);

%% Create a clean discrete-time signal
n = 0:100;
clean = sin(0.1*pi*n);

%% Add noise
noise = 0.4*randn(size(n));
measured = clean + noise;

%% Display the clean and noisy signals
figure('Color','w');
plot(n,clean,'b','LineWidth',1.5);
hold on;
plot(n,measured,'Color',[0.6 0.6 0.6]);
grid on;
xlabel('Sample index n');
ylabel('Amplitude');
title('Clean and Noisy Signals');
legend('Clean Signal','Noisy Signal','Location','best');

%% Task 1: Amplitude scaling
scaled = 2*measured;
figure('Color','w');
plot(n,measured,'Color',[0.6 0.6 0.6],'LineWidth',1);
hold on;
plot(n,scaled,'r','LineWidth',1.3);
grid on;
xlabel('Sample index n');
ylabel('Amplitude');
title('Amplitude Scaling of the Noisy Signal');
legend('Noisy Signal','Scaled Signal (x2)','Location','best');
saveas(gcf,'signal_operations.png');

%% Task 2: Signal delay
delay = 5;
delayed = [zeros(1,delay), measured];
n_measured = 0:length(measured)-1;
n_delayed = 0:length(delayed)-1;
figure('Color','w');
stairs(n_measured,measured,'Color',[0.6 0.6 0.6],'LineWidth',1);
hold on;
stairs(n_delayed,delayed,'r','LineWidth',1.3);
grid on;
xlabel('Sample index n');
ylabel('Amplitude');
title('Five-Sample Delay');
legend('Original Noisy Signal','Delayed Signal','Location','best');
xlim([0 length(delayed)-1]);

%% Task 3: Five-point moving-average filter
h5 = ones(1,5)/5;
filtered5 = conv(measured,h5,'same');
figure('Color','w');
plot(n,clean,'b','LineWidth',1.5);
hold on;
plot(n,measured,'Color',[0.7 0.7 0.7]);
plot(n,filtered5,'r','LineWidth',1.4);
grid on;
xlabel('Sample index n');
ylabel('Amplitude');
title('Five-Point Moving-Average Noise Filtering');
legend('Clean Signal','Noisy Signal','5-Point Filtered Signal','Location','best');
saveas(gcf,'noise_filtering.png');

%% Task 4: Compare two filter lengths
h15 = ones(1,15)/15;
filtered15 = conv(measured,h15,'same');
figure('Color','w');
plot(n,clean,'b-','LineWidth',1.6);
hold on;
plot(n,measured,'Color',[0.75 0.75 0.75],'LineStyle',':');
plot(n,filtered5,'r-','LineWidth',1.3);
plot(n,filtered15,'Color',[0.1 0.55 0.2],'LineStyle','--','LineWidth',1.5);
grid on;
xlabel('Sample index n');
ylabel('Amplitude');
title('Moving-Average Filter Length Comparison');
legend('Clean Signal','Noisy Signal','5-Point Filter','15-Point Filter','Location','best');
saveas(gcf,'filter_comparison.png');
