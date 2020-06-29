load('geometry_results.mat');

figure(1);
surf(outputResultX);
title("Force/Weight Ratio");
xlabel('Width (Bs2)');
ylabel('Depth (Hs2)');
zlabel('Force/Weight');

figure(7);
surf(outputLForcex);
title("Force");
xlabel('Width (Bs2)');
ylabel('Depth (Hs2)');
zlabel('Force');

figure(2);
surf(inputVolume);
title("Volume of Both Cores");
xlabel('Width (Bs2)');
ylabel('Depth (Hs2)');
zlabel('Volume');

figure(3);
surf(outputHLosses);
title("Core Losses");
xlabel('Width (Bs2)');
ylabel('Depth (Hs2)');
zlabel('Core Losses');


figure(4);
surf(inputCoilArea);
title("Coil Area");
xlabel('Width (Bs2)');
ylabel('Depth (Hs2)');
zlabel('Coil Area');


figure(5);
surf(outputLForcex./inputCoilArea);
title("Force/Coil Area");
xlabel('Width (Bs2)');
ylabel('Depth (Hs2)');
zlabel('Force/Coil Area');
