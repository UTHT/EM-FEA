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
title("Unit Core Losses vs Bs2")
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
