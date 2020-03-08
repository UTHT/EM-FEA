load('results.mat');

figure(1);
clf;
hold on;
title("Translational (x) Forces vs NI");
xlabel("NI (At)");
ylabel("Force (N)");
plot(inputNi,outputWSTForcex);
plot(inputNi,outputLForcex);
legend("WST Force","Lorentz Force");
hold off;

figure(2);
clf;
hold on;
title("Stability (y) Forces vs NI");
xlabel("NI (At)");
ylabel("Force (N)");
plot(inputNi,outputWSTForcey);
plot(inputNi,outputLForcey);
legend("WST Force","Lorentz Force");
hold off;

figure(3);
clf;
hold on;
title("Core Losses vs NI");
xlabel("NI (At)");
ylabel("Core Losses (W)");
plot(inputNi,outputHLosses);
plot(inputNi,outputTLosses);
legend("Hysteresis Losses","Total Losses");
hold off;
