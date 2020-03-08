clear;
load('updated_results.mat');

figure(1);
clf;
hold on;
title("Translational Force vs Frequency")
ylabel("Force (N)");
xlabel("Frequency (hz)");
axis([0 300 -inf inf]);
plot(inputFreq,outputLForcex);
plot(inputFreq,outputWSTForcex);
legend('Lorentz Force','WST Force');
hold off;

figure(2);
clf;
hold on;
title("Core Losses vs Frequency")
ylabel("Losses (W)");
xlabel("Frequency (hz)");
axis([0 300 -inf inf]);
plot(inputFreq,outputTLosses);
hold off;

figure(3);
clf;
hold on;
title("Lateral Force vs Frequency")
ylabel("Force (N)");
xlabel("Frequency (hz)");
axis([0 300 -inf inf]);
plot(inputFreq,outputLForcey);
plot(inputFreq,outputWSTForcey);
legend('Lorentz Force','WST Force');
hold off;

figure(4);
clf;
hold on;
title("Synchronous Speed vs Frequency")
ylabel("Speed (kmph)");
xlabel("Frequency (hz)");
axis([0 300 -inf inf]);
plot(inputFreq,syncSpeed*0.0036);
hold off;
