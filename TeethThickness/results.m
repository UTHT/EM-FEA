clear;
load('teeth_thickness_results.mat');

%inputWidth(inputWidth==0)=nan;
nal = 0;

inputTeethThickness = inputSlotPitch-inputBs2;
xtt=inputTeethThickness(:,1)';

figure(1);
clf;
hold on;
title("Translational Unit Force vs Teeth Thickness")
ylabel("Force (N/mm)");
xlabel("TeethThickness (mm)");

axis([nal inf -inf inf]);
for ind = 1:3
  uforce = outputLForcex(:,ind)./(inputWidth(:,ind));
  plot(xtt,uforce');
  %plot(xhs,outputHLosses(ind,:),'DisplayName',sprintf("%d hz",ind*15));
end
legend({'Bs2=10mm','Bs2=15mm','Bs2=20mm'});
hold off;

figure(2);
clf;
hold on;
title("Translational Force vs Teeth Thickness")
ylabel("Force (N)");
xlabel("TeethThickness (mm)");

axis([nal inf -inf inf]);
for ind = 1:3
  plot(xtt,outputLForcex(:,ind)');
  %plot(xhs,outputHLosses(ind,:),'DisplayName',sprintf("%d hz",ind*15));
end
legend({'Bs2=10mm','Bs2=15mm','Bs2=20mm'});
hold off;

figure(3);
clf;
hold on;
title("Unit Core Losses vs Teeth Thickness")
ylabel("Losses (W/mm)");
xlabel("TeethThickness (mm)");

axis([nal inf -inf inf]);
for ind = 1:3
  temp = outputHLosses(:,ind)./(inputWidth(:,ind));
  plot(xtt,temp','DisplayName',sprintf("%d hz",ind*15));
  %plot(xhs,outputHLosses(ind,:),'DisplayName',sprintf("%d hz",ind*15));
end
legend({'Bs2=10mm','Bs2=15mm','Bs2=20mm'});
hold off;

figure(4);
clf;
hold on;
title("Weight vs Teeth Thickness")
ylabel("Weight (kg)");
xlabel("TeethThickness (mm)");

axis([nal inf -inf inf]);
for ind = 1:3
  temp = inputWeight(:,ind)/1000;
  plot(xtt,temp','DisplayName',sprintf("%d hz",ind*15));
  %plot(xhs,outputHLosses(ind,:),'DisplayName',sprintf("%d hz",ind*15));
end
legend({'Bs2=10mm','Bs2=15mm','Bs2=20mm'});
hold off;

figure(5);
clf;
hold on;
title("Unit Weight vs Teeth Thickness")
ylabel("Weight (kg/mm)");
xlabel("TeethThickness (mm)");

axis([nal inf -inf inf]);
for ind = 1:3
  temp = inputWeight(:,ind)./(inputWidth(:,ind))/1000;
  plot(xtt,temp','DisplayName',sprintf("%d hz",ind*15));
  %plot(xhs,outputHLosses(ind,:),'DisplayName',sprintf("%d hz",ind*15));
end
legend({'Bs2=10mm','Bs2=15mm','Bs2=20mm'});
hold off;

figure(6);
clf;
hold on;
title("Synchronous Speed vs Teeth Thickness @ 15 hz")
ylabel("Speed (kmph)");
xlabel("TeethThickness (mm)");

axis([nal inf -inf inf]);
for ind = 1:3
  temp = syncSpeed(:,ind).*3.6/1000;%./(inputWidth(:,ind));
  plot(xtt,temp','DisplayName',sprintf("%d hz",ind*15));
  %plot(xhs,outputHLosses(ind,:),'DisplayName',sprintf("%d hz",ind*15));
end
legend({'Bs2=10mm','Bs2=15mm','Bs2=20mm'});
hold off;

figure(7);
clf;
hold on;
title("Phase A Power vs Bs2")
ylabel("Power (W)");
xlabel("Teeth Thickness (mm)");
axis([nal inf -inf inf]);
for ind = 1:3
  outputPowerA = conj(outputCurrentA(:,ind)).*outputVoltageA(:,ind)/2;
  %outputPowerB = conj(outputCurrentB(:,ind)).*outputVoltageB(:,ind)/2;
  %outputPowerC = conj(outputCurrentC(:,ind)).*outputVoltageC(:,ind)/2;
  plot(xtt,real(outputPowerA));
  %plot(xbs,real(outputPowerB),'DisplayName',sprintf("vB@%dhz",ind*15));
  %plot(xbs,real(outputPowerC),'DisplayName',sprintf("vC@%dhz",ind*15));
end
legend({'Bs2=10mm','Bs2=15mm','Bs2=20mm'});

figure(8);
clf;
hold on;
title("Phase B Power vs Bs2")
ylabel("Power (W)");
xlabel("Teeth Thickness (mm)");
axis([nal inf -inf inf]);
for ind = 1:3
  outputPowerB = conj(outputCurrentB(:,ind)).*outputVoltageB(:,ind)/2;
  plot(xtt,real(outputPowerB));
end
legend({'Bs2=10mm','Bs2=15mm','Bs2=20mm'});

figure(9);
clf;
hold on;
title("Phase C Power vs Bs2")
ylabel("Power (W)");
xlabel("Teeth Thickness (mm)");
axis([nal inf -inf inf]);
for ind = 1:3
  outputPowerC = conj(outputCurrentC(:,ind)).*outputVoltageC(:,ind)/2;
  plot(xtt,real(outputPowerC));
end
legend({'Bs2=10mm','Bs2=15mm','Bs2=20mm'});


figure(10);
clf;
hold on;
title("Core Losses vs Teeth Thickness")
ylabel("Losses (W)");
xlabel("TeethThickness (mm)");

axis([nal inf -inf inf]);
for ind = 1:3
  temp = outputHLosses(:,ind);
  plot(xtt,temp','DisplayName',sprintf("%d hz",ind*15));
  %plot(xhs,outputHLosses(ind,:),'DisplayName',sprintf("%d hz",ind*15));
end
legend({'Bs2=10mm','Bs2=15mm','Bs2=20mm'});
hold off;