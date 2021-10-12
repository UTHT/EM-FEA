clear;
load('final_results.mat');

min_airgap = 6;
max_airgap = 30;
L = max_airgap-min_airgap+1;

% figure(1);
% surf(inputCoreOffset);
% axis([1 24 6 30]);
% title("Core Offset");
% xlabel("Core Offset (mm)");
% ylabel("Air Gap (mm)");
%
% figure(2);
% surf(inputAirGap);
% axis([1 24 6 30]);
% title("Air Gap ");
% xlabel("Core Offset (mm)");
% ylabel("Air Gap (mm)");
%
%
% figure(3);
% surf(outputWSTForcex);
% axis([1 24 6 30]);
% title("WST Thrust");
% xlabel("Core Offset (mm)");
% ylabel("Air Gap (mm)");

figure(1);
clf;
title("Thrust Forces vs Core Offset")
plot(inputAirGap,outputWSTForcex);
plot(inputAirGap,outputLForcex);
legend("WST Force","Lorentz Force");
hold off;
