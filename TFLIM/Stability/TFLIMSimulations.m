function [hysteresisLosses,totalLosses,lforcex,lforcey,wstforcex,wstforcey,phaseLvol,phaseRvol,phaseLcur,phaseRcur,phaseLfl,phaseRfl] = TFLIMSimulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH,THICK_CORE,LENGTH,TEETH_THICKNESS,CORE_THICKNESS,COIL_WIDTH,TEETH_EXTENSIONS,AIR_GAP,TRACK_OFFSET,simulationNumber)

%Define simulation/modeller units
unit = 'millimeters';

plotUpperLimit = 1;
plotLowerLimit = 0.0;
paddingRatio = 1.1;

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

LPhase = inputCurrent*(cos(angle*pi/180)+sin(angle*pi/180)*j);
RPhase = inputCurrent*(cos(angle*pi/180)+sin(angle*pi/180)*j);
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
mi_selectrectangle(-totalwidth,-TEETH_EXTENSIONS,totalwidth,THICK_CORE,4);
mi_setgroup(1);

%Create Space for Air Gap and Track
mi_selectgroup(1);
mi_movetranslate(0,AIR_GAP+TEETH_EXTENSIONS);

%Create Track
mi_selectrectangle(-totalwidth*1.5+TRACK_OFFSET,-trackThickness/2,totalwidth*1.5+TRACK_OFFSET,trackThickness/2);
mi_setgroup(2);
mi_addblocklabel(0,0);
mi_selectlabel(0,0);
mi_setblockprop(trackMaterial,1,0,'<None>',0,2,0);
mi_drawrectangle(-totalwidth*1.5+TRACK_OFFSET,-trackThickness/2,totalwidth*1.5+TRACK_OFFSET,trackThickness/2);
mi_clearselected;

mi_zoomnatural;
mi_makeABC;
mi_saveas(append('..\SimulationData\temp_',num2str(simulationNumber),'.fem'));
mi_analyze;
mi_loadsolution;

mo_selectblock(0,0);
lforcex = mo_blockintegral(11);
lforcey = mo_blockintegral(12);
wstforcex = mo_blockintegral(18);
wstforcey = mo_blockintegral(19);

mo_clearblock;

mo_selectblock(0,AIR_GAP+TEETH_EXTENSIONS+THICK_CORE-CORE_THICKNESS/2);
hysteresisLosses = mo_blockintegral(3);
totalLosses= mo_blockintegral(6);

mo_clearblock;

phaseLprop = mo_getcircuitproperties('WindingL');
phaseRprop = mo_getcircuitproperties('WindingR');

phaseLcur = phaseLprop(1);
phaseRcur = phaseRprop(1);

phaseLvol = phaseLprop(2);
phaseRvol = phaseRprop(2);

phaseLfl = phaseLprop(3);
phaseRfl = phaseRprop(3);

%Save Image
%leftBound = (-totalwidth*1.5+TRACK_OFFSET)*paddingRatio;
%rightBound = (totalwidth*1.5+TRACK_OFFSET)*paddingRatio;
%topBound = (100)*paddingRatio;
%botBound = -(15)*paddingRatio;
%mo_showdensityplot(0,0,plotUpperLimit,plotLowerLimit,'real');
%mo_zoom(leftBound,botBound,rightBound,topBound);
%mo_savebitmap('TFLIM.jpg');

end
