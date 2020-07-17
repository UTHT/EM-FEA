function [phaseA,phaseB,phaseC] = define_excitations_td(c,f,time)

  wt = 2*pi*f*time;
  phaseA = c*exp(wt*j);
  phaseB = c*exp(wt*j+2*pi/3*j);
  phaseC = c*exp(wt*j+4*pi/3*j);
  mi_addcircprop('WindingA',phaseA,1);
  mi_addcircprop('WindingB',phaseB,1);
  mi_addcircprop('WindingC',phaseC,1);
