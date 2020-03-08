load('NI_results.mat');

figure(1);
clf;
hold on;
title("Translational (x) Forces vs NI");
xlabel("NI (At)");
ylabel("Force (N)");
axis([0 6000 0 1800]);
plot(NI,WSTForceX);
plot(NI,LorentzForceX);
legend("WST Force","Lorentz Force");
hold off;

figure(2);
clf;
hold on;
title("Stability (y) Forces vs NI");
xlabel("NI (At)");
ylabel("Force (N)");
plot(NI,WSTForceY);
plot(NI,LorentzForceY);
axis([0 6000 -0.5 0.5]);
legend("WST Force","Lorentz Force");
hold off;

figure(3);
clf;
hold on;
title("Core Losses vs NI");
xlabel("NI (At)");
ylabel("Core Losses (W)");
plot(NI,HLosses);
plot(NI,TLosses);
axis([0 6000 0 0.5]);
legend("Hysteresis Losses","Total Losses");
hold off;
