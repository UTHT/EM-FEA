load('geometry_results_0205.mat');

figure(1);
surf(outputResultX);
title("Force/Weight Ratio");
xlabel('Depth (Hs2)');
ylabel('Width (Bs2)');
zlabel('Force/Weight');

figure(4);
surf(outputLForcex);
title("Force");
xlabel('Depth (Hs2)');
ylabel('Width (Bs2)');
zlabel('Force');

figure(2);
surf(inputVolume);
title("Volume of Both Cores");
xlabel('Depth (Hs2)');
ylabel('Width (Bs2)');
zlabel('Volume');

figure(3);
surf(outputHLosses);
title("Core Losses");
xlabel('Depth (Hs2)');
ylabel('Width (Hs2)');
zlabel('Core Losse');
