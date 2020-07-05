function [hysteresisLosses,totalLosses,lforcex,lforcey,wstforcex,wstforcey,phaseAvol,phaseBvol,phaseCvol,phaseAcur,phaseBcur,phaseCcur,phaseAfl,phaseBfl,phaseCfl] = DLIM_GRWv2_Simulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH_CORE,THICK_CORE,LENGTH,GAP,SLOT_PITCH,SLOTS,Hs0,Hs01,Hs1,Hs2,Bs0,Bs1,Bs2,Rs,Layers,COIL_PITCH,CORE_ENDLENGTH,COIL_THICKNESS,simulationNumber)

%Define simulation/modeller units
unit = 'millimeters';

plotUpperLimit = 1;
plotLowerLimit = 0.0;
paddingRatio = 1;

%Define Simulation Specific Parameters
sumSlotTeeth = SLOTS*2+1; %Number of Teeth + Slots
slotGap = SLOT_PITCH-Bs1; %Width of an Individual Slot
slotTeethWidth = (SLOTS-1)*SLOT_PITCH+slotGap;
coilArea = slotGap*Hs2/2; %Area of coil for a single phase

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

%Define LIM Geometry Variables
sumSlotTeeth = SLOTS*2+1;
slotGap = Bs2;
teethThickness = SLOT_PITCH-Bs2;
slotTeethWidth = (SLOTS-1)*SLOT_PITCH+slotGap;

%Start define LIM Core Geometry

%Define LIM core external dimensions
mi_addnode(WIDTH_CORE/-2-CORE_ENDLENGTH,THICK_CORE);
mi_addnode(WIDTH_CORE/2+CORE_ENDLENGTH,THICK_CORE);
mi_addnode(WIDTH_CORE/-2-CORE_ENDLENGTH,0);
mi_addnode(WIDTH_CORE/2+CORE_ENDLENGTH,0);

mi_addsegment(WIDTH_CORE/-2-CORE_ENDLENGTH,THICK_CORE,WIDTH_CORE/2+CORE_ENDLENGTH,THICK_CORE);
mi_addsegment(WIDTH_CORE/-2-CORE_ENDLENGTH,0,WIDTH_CORE/-2-CORE_ENDLENGTH,THICK_CORE);
mi_addsegment(WIDTH_CORE/2+CORE_ENDLENGTH,0,WIDTH_CORE/2+CORE_ENDLENGTH,THICK_CORE);

%Define teeth,slot and winding geometries
for i=0:SLOTS-1
    delta = SLOT_PITCH*i;
    mi_drawline(-slotTeethWidth/2+delta,0,-slotTeethWidth/2+delta,Hs2);
    mi_drawline(-slotTeethWidth/2+slotGap+delta,0,-slotTeethWidth/2+slotGap+delta,Hs2);
    mi_addsegment(-slotTeethWidth/2+delta,Hs2,-slotTeethWidth/2+delta+slotGap,Hs2);

    mi_drawline(-slotTeethWidth/2+delta,Hs2-COIL_THICKNESS,-slotTeethWidth/2+slotGap+delta,Hs2-COIL_THICKNESS);
    mi_addnode(-slotTeethWidth/2+delta,THICK_CORE);
    mi_addnode(-slotTeethWidth/2+delta+slotGap,THICK_CORE)
    mi_drawline(-slotTeethWidth/2+delta,THICK_CORE,-slotTeethWidth/2+delta,THICK_CORE+COIL_THICKNESS);
    mi_drawline(-slotTeethWidth/2+delta+slotGap,THICK_CORE,-slotTeethWidth/2+delta+slotGap,THICK_CORE+COIL_THICKNESS);
    mi_addsegment(-slotTeethWidth/2+delta,THICK_CORE+COIL_THICKNESS,-slotTeethWidth/2+delta+slotGap,THICK_CORE+COIL_THICKNESS);
end

%for i=0:SLOTS-2
%    delta=SLOT_PITCH*i;
%    mi_addsegment(-slotTeethWidth/2+slotGap+delta,0,-slotTeethWidth/2+slotGap+delta+Bs1,0);
%end

mi_addsegment(WIDTH_CORE/-2-CORE_ENDLENGTH,0,-slotTeethWidth/2,0);
mi_addsegment(slotTeethWidth/2,0,WIDTH_CORE/2+CORE_ENDLENGTH,0);

%Define Coil Currents
wt = 0*2*pi*freq;%*time;
phaseA = inputCurrent*exp(wt*j);
phaseB = inputCurrent*exp(wt*j+2*pi/3*j);
phaseC = inputCurrent*exp(wt*j+4*pi/3*j);
mi_addcircprop('WindingA',phaseA,1);
mi_addcircprop('WindingB',phaseB,1);
mi_addcircprop('WindingC',phaseC,1);

%Create and Label Coils with proper phase setup
for i=0:SLOTS-1
   delta=SLOT_PITCH*i;

   phase = mod(i,3);
   orientation = mod(floor(i/3),2);
   winding = '';

   if(phase==0)
       winding='WindingA';
   elseif(phase==1)
       winding='WindingB';
   elseif(phase==2)
       winding='WindingC';
   end

   mi_addblocklabel(-slotTeethWidth/2+slotGap/2+delta,(Hs2+Hs2-COIL_THICKNESS)/2);
   mi_addblocklabel(-slotTeethWidth/2+slotGap/2+delta,THICK_CORE+COIL_THICKNESS/2);
   mi_addblocklabel(-slotTeethWidth/2+slotGap/2+delta,(Hs2-COIL_THICKNESS)/2);

   mi_selectlabel(-slotTeethWidth/2+slotGap/2+delta,(Hs2+Hs2-COIL_THICKNESS)/2);
   mi_setblockprop(copperMaterial,1,0,winding,0,1,((-1)^orientation)*-coilTurns);
   mi_clearselected;

   mi_selectlabel(-slotTeethWidth/2+slotGap/2+delta,THICK_CORE+COIL_THICKNESS/2);
   mi_setblockprop(copperMaterial,1,0,winding,0,1,((-1)^orientation)*coilTurns);
   mi_clearselected;

   mi_selectlabel(-slotTeethWidth/2+slotGap/2+delta,(Hs2-COIL_THICKNESS)/2);
   mi_setblockprop(Air,1,0,'<None>',0,0,0);
   mi_clearselected;
end

%Select LIM Geometry and set to group 1
mi_selectrectangle(WIDTH_CORE/-2-CORE_ENDLENGTH,0,WIDTH_CORE/2+CORE_ENDLENGTH,THICK_CORE+COIL_THICKNESS,4);
mi_setgroup(1);

%Label LIM Geometry
mi_addblocklabel(0,(Hs2+THICK_CORE)/2);
mi_selectlabel(0,(Hs2+THICK_CORE)/2);
mi_setblockprop(coreMaterial,1,0,'<None>',0,1,0);

%Create Space for Air Gap and Track
mi_selectgroup(1);
mi_movetranslate(0,GAP);

%Create and Label Air Gap
mi_addsegment(WIDTH_CORE/-2-CORE_ENDLENGTH,GAP,WIDTH_CORE/2+CORE_ENDLENGTH,GAP);
mi_selectrectangle(WIDTH_CORE/-2-CORE_ENDLENGTH,trackThickness/2,WIDTH_CORE/2+CORE_ENDLENGTH,GAP);
mi_setgroup(1);
%mi_addblocklabel(0,GAP/2);
%mi_selectlabel(0,GAP/2);
mi_setblockprop(Air,1,0,'<None>',0,1,0);

%Mirror one side to create DLIM
mi_selectgroup(1);
mi_mirror(WIDTH_CORE/-2-CORE_ENDLENGTH,0,WIDTH_CORE/2+CORE_ENDLENGTH,0);

%Create Track
mi_drawrectangle(WIDTH_CORE/-2-CORE_ENDLENGTH-100,trackThickness/-2,WIDTH_CORE/2+CORE_ENDLENGTH+100,trackThickness/2);
mi_selectrectangle(WIDTH_CORE/-2-CORE_ENDLENGTH-100,trackThickness/-2,WIDTH_CORE/2+CORE_ENDLENGTH+100,trackThickness/2);
mi_setgroup(2);
mi_addblocklabel(0,0);
mi_selectlabel(0,0);
mi_setblockprop(trackMaterial,1,0,'<None>',0,2,0);
mi_clearselected;

%Final Adjustments
mi_zoomnatural;
mi_addblocklabel(0,THICK_CORE*2);
mi_selectlabel(0,THICK_CORE*2);
mi_setblockprop(Air,1,0,'<None>',0,0,0);
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

mo_selectblock(0,(Hs2+THICK_CORE)/2+GAP);
hysteresisLosses = mo_blockintegral(3);
totalLosses= mo_blockintegral(6);

phaseAprop = mo_getcircuitproperties('WindingA');
phaseBprop = mo_getcircuitproperties('WindingB');
phaseCprop = mo_getcircuitproperties('WindingC');

phaseAcur = phaseAprop(1);
phaseBcur = phaseBprop(1);
phaseCcur = phaseCprop(1);

phaseAvol = phaseAprop(2);
phaseBvol = phaseBprop(2);
phaseCvol = phaseCprop(2);

phaseAfl = phaseAprop(3);
phaseBfl = phaseBprop(3);
phaseCfl = phaseCprop(3);

mo_clearblock;

%Save Image
leftBound = (WIDTH_CORE/-2-CORE_ENDLENGTH-100)*paddingRatio;
rightBound = (WIDTH_CORE/2+CORE_ENDLENGTH+100)*paddingRatio;
topBound = (100)*paddingRatio;
botBound = -(150)*paddingRatio;
mo_showdensityplot(0,0,plotUpperLimit,plotLowerLimit,'real');
mo_zoom(leftBound,botBound,rightBound,topBound);
mo_savebitmap(sprintf('.\res\DLIM_num_%04d.jpg',simulationNumber))

end
