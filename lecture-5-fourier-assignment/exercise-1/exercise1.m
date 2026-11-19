% Exercise 1: Square wave approximation from odd harmonics
clear; close all; clc;
t = linspace(-1, 1, 4000);
Hvalues = [1 3 9 25];
figure('Color','w','Position',[100 100 1000 700]);
tiledlayout(2,2,'TileSpacing','compact');
for idx = 1:numel(Hvalues)
    H = Hvalues(idx);
    x = zeros(size(t));
    for k = 1:2:H
        x = x + (4/pi) * sin(2*pi*k*t) / k;
    end
    nexttile;
    plot(t,x,'LineWidth',1.1); grid on; ylim([-1.5 1.5]); xlim([-1 1]);
    xlabel('Time (s)'); ylabel('Amplitude');
    title(sprintf('Odd harmonics through H = %d',H));
end
sgtitle('Square wave approximation as harmonics are added');
exportgraphics(gcf, fullfile(fileparts(mfilename('fullpath')),'square-wave-comparison.png'),'Resolution',180);
