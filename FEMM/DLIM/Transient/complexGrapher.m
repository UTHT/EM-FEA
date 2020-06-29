title("Number Grapher")

freq = 120;
time = 0;
inputCurrent=1;

figure(1);
clf;
hold on;
axis([-inputCurrent inputCurrent -inputCurrent inputCurrent])

for i=0:100
  time = i/60/100;
  wt = 2*pi*freq*time;

  phaseA = inputCurrent*exp(wt*j);
  phaseB = inputCurrent*exp(wt*j+2*pi/3*j);
  phaseC = inputCurrent*exp(wt*j+4*pi/3*j);

  phaseAre = real(phaseA);
  phaseBre = real(phaseB);
  phaseCre = real(phaseC);

  phaseAim = imag(phaseA);
  phaseBim = imag(phaseB);
  phaseCim = imag(phaseC);

  plot(phaseAre,phaseAim,'ro');
  plot(phaseBre,phaseBim,'bo');
  plot(phaseCre,phaseCim,'go');
  pause(1)
end
