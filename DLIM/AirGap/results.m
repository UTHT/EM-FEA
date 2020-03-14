load('gap_results.mat');

figure(1);
clf;
hold on;
plot(outputWSTForcex,'DisplayName','WST Force,ni=3100');

load('results.mat');

plot(outputWSTForcex,'DisplayName','WST Force,ni=3600');

xt = get(gca,'XTick');
set(gca,'XTick',xt,'XTickLabel',xt/10)
x = [0.3,6/30];
y = [0.2,0.115];
a = annotation('textarrow',x,y,'String','Air Gap < Track Thickness');
title("Translational Force vs Air Gap")
xlabel('Air Gap (mm)')
ylabel('Force (N)')
legend;

load('gap_results.mat');

figure(2);
clf;
hold on;

plot(outputTLosses,'DisplayName','Total Core Losses,ni=3100');

load('results.mat');

plot(outputTLosses,'DisplayName','Total Core Losses,ni=3600');

xt = get(gca,'XTick');
set(gca,'XTick',xt,'XTickLabel',xt/10)
title("Core Losses vs Air Gap")
xlabel('Air Gap (mm)')
ylabel('Core Losses (W)')
legend;


load('gap_results.mat');

figure(3);
clf;
hold on;

plot(abs(outputVoltageA),'DisplayName','Phase A Voltage,ni=3100');
plot(abs(outputVoltageB),'DisplayName','Phase B Voltage,ni=3100');
plot(abs(outputVoltageC),'DisplayName','Phase C Voltage,ni=3100');

load('results.mat');

plot(abs(outputVoltageA),'DisplayName','Phase A Voltage,ni=3600');
plot(abs(outputVoltageB),'DisplayName','Phase B Voltage,ni=3600');
plot(abs(outputVoltageC),'DisplayName','Phase C Voltage,ni=3600');

xt = get(gca,'XTick');
set(gca,'XTick',xt,'XTickLabel',xt/10)
title("Voltage vs Air Gap")
xlabel('Air Gap (mm)')
ylabel('Voltage (V)')
legend;
