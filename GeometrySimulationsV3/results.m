clear;
load('frequency_variant.mat');


xbs = inputBs2(ind,:);
xhs = 400./inputBs2(ind,:);

%inputWidth(inputWidth==0)=nan;
nal = 5;

figure(1);
clf;
hold on;
title("Translational Unit Force vs Bs2")
ylabel("Force (N/mm)");
xlabel("Bs2 (mm)");

axis([nal inf -inf inf]);
for ind = 1:10
  temp = outputLForcex(ind,:)./(inputWidth(ind,:));
  plot(xbs,temp,'DisplayName',sprintf("%d hz",ind*15));
  legend('show');
  %plot(xhs,outputHLosses(ind,:),'DisplayName',sprintf("%d hz",ind*15));
end
legend;
hold off;

figure(2);
clf;
hold on;
title("Unit Core Losses vs Bs2")
ylabel("Losses (W/mm)");
xlabel("Bs2 (mm)");

axis([nal inf -inf inf]);
for ind = 1:10
  temp = outputHLosses(ind,:)./(inputWidth(ind,:));
  plot(xbs,temp,'DisplayName',sprintf("%d hz",ind*15));
  legend('show');
  %plot(xhs,outputHLosses(ind,:),'DisplayName',sprintf("%d hz",ind*15));
end
hold off;



figure(3);
clf;
hold on;
title(" Weight vs Bs2")
ylabel("Weight (g/mm)");
xlabel("Bs2 (mm)");
axis([nal inf -inf inf]);
temp = double(inputWeight(ind,:))./1000;
plot(xbs,temp,'DisplayName','vs. Bs2');
plot(xhs,temp,'DisplayName','vs. Hs2');
legend('show');


figure(4);
clf;
hold on;
title("Speed vs Bs2")
ylabel("Speed ((kmph)/mm)");
xlabel("Bs2 (mm)");
axis([nal inf -inf inf]);
for ind = 1:10
  temp = syncSpeed(ind,:).*3.6./1000;
  plot(xbs,temp,'DisplayName',sprintf("%d hz",ind*15));
  legend('show');
end

figure(5);
clf;
hold on;
title("Normalized Phase A Power (/Core Length) vs Bs2")
ylabel("Normalized Power (W/mm)");
xlabel("Bs2 (mm)");
axis([nal inf -inf inf]);
for ind = 1:10
  outputPowerA = conj(outputCurrentA(ind,:)).*outputVoltageA(ind,:)/2./inputWidth(ind,:);
  %outputPowerB = conj(outputCurrentB(ind,:)).*outputVoltageB(ind,:)/2;
  %outputPowerC = conj(outputCurrentC(ind,:)).*outputVoltageC(ind,:)/2;
  plot(xbs,real(outputPowerA),'DisplayName',sprintf("vA@%dhz",ind*15));
  %plot(xbs,real(outputPowerB),'DisplayName',sprintf("vB@%dhz",ind*15));
  %plot(xbs,real(outputPowerC),'DisplayName',sprintf("vC@%dhz",ind*15));

  legend('show');
end

figure(6);
clf;
hold on;
title("Phase A Power vs Bs2")
ylabel("Power (W)");
xlabel("Bs2 (mm)");
axis([nal inf -inf inf]);
for ind = 1:10
  outputPowerA = conj(outputCurrentA(ind,:)).*outputVoltageA(ind,:)/2;
  %outputPowerB = conj(outputCurrentB(ind,:)).*outputVoltageB(ind,:)/2;
  %outputPowerC = conj(outputCurrentC(ind,:)).*outputVoltageC(ind,:)/2;
  plot(xbs,real(outputPowerA),'DisplayName',sprintf("vA@%dhz",ind*15));
  %plot(xbs,real(outputPowerB),'DisplayName',sprintf("vB@%dhz",ind*15));
  %plot(xbs,real(outputPowerC),'DisplayName',sprintf("vC@%dhz",ind*15));

  legend('show');
end

figure(7);
clf;
hold on;
title("Phase B Power vs Bs2")
ylabel("Power (W)");
xlabel("Bs2 (mm)");
axis([nal inf -inf inf]);
for ind = 1:10
  outputPowerB = conj(outputCurrentB(ind,:)).*outputVoltageB(ind,:)/2;
  plot(xbs,real(outputPowerB),'DisplayName',sprintf("vB@%dhz",ind*15));
  legend('show');
end

figure(8);
clf;
hold on;
title("Phase C Power vs Bs2")
ylabel("Power (W)");
xlabel("Bs2 (mm)");
axis([nal inf -inf inf]);
for ind = 1:10
  outputPowerC = conj(outputCurrentC(ind,:)).*outputVoltageC(ind,:)/2;
  plot(xbs,real(outputPowerC),'DisplayName',sprintf("vC@%dhz",ind*15));

  legend('show');
end
