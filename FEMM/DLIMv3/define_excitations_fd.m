function [phaseA,phaseB,phaseC] = define_excitations_fd(inputCurrent,angle)

phaseA = inputCurrent*(cos(angle*pi/180)+sin(angle*pi/180)*j);
phaseB = inputCurrent*(cos((120+angle)*pi/180)+sin((120+angle)*pi/180)*j);
phaseC = inputCurrent*(cos((240+angle)*pi/180)+sin((240+angle)*pi/180)*j);
mi_addcircprop('WindingA',phaseA,1);
mi_addcircprop('WindingB',phaseB,1);
mi_addcircprop('WindingC',phaseC,1);
