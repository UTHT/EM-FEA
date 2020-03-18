%function [hysteresisLosses,totalLosses,lforcex,lforcey,wstforcex,wstforcey,phaseAvol,phaseBvol,phaseCvol,phaseAcur,phaseBcur,phaseCcur,phaseAfl,phaseBfl,phaseCfl]
%  = TFLIMSimulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH_CORE,THICK_CORE,LENGTH,GAP,SLOT_PITCH,SLOTS,Hs0,Hs01,Hs1,Hs2,Bs0,Bs1,Bs2,Rs,Layers,COIL_PITCH,END_EXT)









inputCurrent = 10;
freq = 15;
coilTurns = 310;
trackThickness = 8;
copperMaterial = '20 AWG';
trackMaterial = 'Aluminum, 6061-T6';
coreMaterial = 'M-19 Steel';


THICK_CORE=60;
WIDTH = 100;
LENGTH = 50; %Core length
TEETH_THICKNESS = 25;
CORE_THICKNESS = 20;
COIL_WIDTH=15;
TEETH_EXTENSIONS=10;
AIR_GAP=5;
TRACK_OFFSET=0;

%Define simulation/modeller units
unit = 'millimeters';

plotUpperLimit = 1;
plotLowerLimit = 0.0;
paddingRatio = 1;

%Open FEMM and resize window
openfemm(0);
main_resize(1000,590);

%Create new document and define problem solution
newdocument(0);

%Define problem setup
mi_probdef(freq,unit,'planar',1e-8,LENGTH,30);

%Get Lim Materials
Air = 'Air';
mi_getmaterial(Air);
mi_getmaterial(copperMaterial);
mi_getmaterial(trackMaterial);
mi_getmaterial(coreMaterial);

mi_modifymaterial(coreMaterial,6,0.5);

leftbound = -WIDTH/2;
rightbound = WIDTH/2;
innerleftbound = leftbound+TEETH_THICKNESS;
innerrightbound = rightbound-TEETH_THICKNESS;
innertopbound = THICK_CORE-CORE_THICKNESS;

mi_addnode(leftbound,-TEETH_EXTENSIONS);
mi_addnode(leftbound,THICK_CORE);
mi_addnode(rightbound,-TEETH_EXTENSIONS);
mi_addnode(rightbound,THICK_CORE);

mi_addsegment(leftbound,-TEETH_EXTENSIONS,leftbound,THICK_CORE);
mi_addsegment(rightbound,-TEETH_EXTENSIONS,rightbound,THICK_CORE);
mi_addsegment(leftbound,THICK_CORE,rightbound,THICK_CORE);

mi_addnode(innerleftbound,-TEETH_EXTENSIONS);
mi_addnode(innerrightbound,-TEETH_EXTENSIONS);
mi_addnode(innerleftbound,innertopbound);
mi_addnode(innerrightbound,innertopbound);

mi_addsegment(innerleftbound,innertopbound,innerrightbound,innertopbound);
mi_addsegment(innerleftbound,0,innerleftbound,innertopbound);
mi_addsegment(innerrightbound,0,innerrightbound,innertopbound);
mi_addsegment(leftbound,0,innerleftbound,0);
mi_addsegment(rightbound,0,innerrightbound,0);

LPhase = inputCurrent;
RPhase = inputCurrent;
mi_addcircprop('WindingL',LPhase,1);
mi_addcircprop('WindingR',RPhase,1);

%Define interior copper windings
if(COIL_WIDTH*2>=WIDTH-2*TEETH_THICKNESS)
  disp("Warning: Coil Width potentially larger than inter teeth distance. Reducing coil width size...")
  mi_addnode(0,0);
  mi_addnode(0,innertopbound);
  mi_addnode(innerleftbound,0);
  mi_addnode(innerrightbound,0);
  mi_addsegment(0,0,0,innertopbound);
  mi_addsegment(0,0,innerleftbound,0);
  mi_addsegment(0,0,innerrightbound,0);
  COIL_WIDTH=(WIDTH-2*TEETH_THICKNESS)/2;


else
  mi_addnode(innerleftbound+COIL_WIDTH,0);
  mi_addnode(innerrightbound-COIL_WIDTH,0);
  mi_drawrectangle(innerleftbound+COIL_WIDTH,0,innerleftbound,innertopbound);
  mi_drawrectangle(innerrightbound-COIL_WIDTH,0,innerrightbound,innertopbound);


end

mi_addblocklabel(innerleftbound+COIL_WIDTH/2,innertopbound/2);
mi_selectlabel(innerleftbound+COIL_WIDTH/2,innertopbound/2);
mi_setblockprop(copperMaterial,1,0,'WindingL',0,1,coilTurns);
mi_clearselected;

mi_addblocklabel(innerrightbound-COIL_WIDTH/2,innertopbound/2);
mi_selectlabel(innerrightbound-COIL_WIDTH/2,innertopbound/2);
mi_setblockprop(copperMaterial,1,0,'WindingR',0,1,coilTurns);
mi_clearselected;

%Define exterior copper windings
totalwidth = WIDTH/2+COIL_WIDTH;

mi_drawrectangle(-totalwidth,0,leftbound,innertopbound);
mi_drawrectangle(totalwidth,0,rightbound,innertopbound);

mi_addblocklabel(-totalwidth+COIL_WIDTH/2,innertopbound/2);
mi_selectlabel(-totalwidth+COIL_WIDTH/2,innertopbound/2);
mi_setblockprop(copperMaterial,1,0,'WindingL',0,1,-coilTurns);
mi_clearselected;

mi_addblocklabel(totalwidth-COIL_WIDTH/2,innertopbound/2);
mi_selectlabel(totalwidth-COIL_WIDTH/2,innertopbound/2);
mi_setblockprop(copperMaterial,1,0,'WindingR',0,1,-coilTurns);
mi_clearselected;


%Select and label LIM Core
mi_addblocklabel(0,THICK_CORE-CORE_THICKNESS/2);
mi_selectlabel(0,THICK_CORE-CORE_THICKNESS/2);
mi_setblockprop(coreMaterial,1,0,'<None>',0,1,0);
mi_clearselected;

%Select and label air region
mi_addblocklabel(0,THICK_CORE+5);
mi_selectlabel(0,THICK_CORE+5);
mi_setblockprop(Air,1,0,'<None>',0,1,0);
mi_clearselected;

%Select LIM Geometry and set to group 1
mi_selectrectangle(-totalwidth,-TEETH_EXTENSIONS,totalwidth,THICK_CORE+5,4);
mi_setgroup(1);

%Create Space for Air Gap and Track
mi_selectgroup(1);
mi_movetranslate(0,AIR_GAP+TEETH_EXTENSIONS);

%Create Track
mi_drawrectangle(-totalwidth*1.5+TRACK_OFFSET,-trackThickness/2,totalwidth*1.5+TRACK_OFFSET,trackThickness/2);
mi_selectrectangle(-totalwidth*1.5+TRACK_OFFSET,-trackThickness/2,totalwidth*1.5+TRACK_OFFSET,trackThickness/2);
mi_setgroup(2);
mi_addblocklabel(0,0);
mi_selectlabel(0,0);
mi_setblockprop(trackMaterial,1,0,'<None>',0,2,0);
mi_clearselected;

mi_zoomnatural;
mi_makeABC;
mi_saveas('SimulationData\TFLIMSimulations.fem');
mi_analyze;
mi_loadsolution;
