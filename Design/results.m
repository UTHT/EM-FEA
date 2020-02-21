load('final_results.mat');

figure(1);
surf(outputResultX);
title("Translational Force/Weight Ratio ");
xlabel('Width (END\_EXT)');
ylabel('Depth (THICK\_CORE-Hs2)');
zlabel('Force/Weight');

figure(2);
surf(outputLForcex);
title("Translational Force");
xlabel('Width (END\_EXT)');
ylabel('Depth (THICK\_CORE-Hs2)');
zlabel('Force (N)');

figure(7);
surf(outputLForcey);
title("Lateral Force");
xlabel('Width (END\_EXT)');
ylabel('Depth (THICK\_CORE-Hs2)');
zlabel('Force (N)');

figure(3);
surf(inputVolume);
title("Volume or Core Weight");
xlabel('Width (END\_EXT)');
ylabel('Depth (THICK\_CORE-Hs2)');
zlabel('Volume');

figure(4);
surf(outputHLosses);
title("Core Losses");
xlabel('Width (END\_EXT)');
ylabel('Depth (THICK\_CORE-Hs2)');
zlabel('Core Losses');

figure(5);
surf(outputHLosses./inputVolume);
title("Core Losses/Core Volume");
xlabel('Width (END\_EXT)');
ylabel('Depth (THICK\_CORE-Hs2)');
zlabel('Core Losses/Core Volume');
