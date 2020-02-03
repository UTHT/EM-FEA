function [hysteresisLosses,totalLosses,lforcex,lforcey,wstforcex,wstforcey,phaseAvol,phaseBvol,phaseCvol,phaseAcur,phaseBcur,phaseCcur] = DLIMSimulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH_CORE,THICK_CORE,LENGTH,GAP,SLOT_PITCH,SLOTS,Hs0,Hs01,Hs1,Hs2,Bs0,Bs1,Bs2,Rs,Layers,COIL_PITCH)

unit = 'millimeters';

EnableBavg = false;
EnableBn = true;
EnableTorque = false;

%Open FEMM and resize window
openfemm(0);
%main_resize(1000,590);

%Create new document and define problem solution
newdocument(0);
mi_probdef(freq,unit,'planar',1e-8,LENGTH,30);
%Get Lim Materials
Air = 'Air';
mi_getmaterial(Air);
mi_getmaterial(copperMaterial);
mi_getmaterial(coreMaterial);
mi_getmaterial(trackMaterial);

%Define LIM Geometry Variables
sumSlotTeeth = SLOTS*2+1;
slotGap = SLOT_PITCH-Bs1;
slotTeethWidth = (SLOTS-1)*SLOT_PITCH+slotGap;

%Define LIM Core Geometry
mi_addnode(WIDTH_CORE/-2,THICK_CORE);
mi_addnode(WIDTH_CORE/2,THICK_CORE);
mi_addnode(WIDTH_CORE/-2,0);
mi_addnode(WIDTH_CORE/2,0);

mi_addsegment(WIDTH_CORE/-2,THICK_CORE,WIDTH_CORE/2,THICK_CORE);
mi_addsegment(WIDTH_CORE/-2,0,WIDTH_CORE/-2,THICK_CORE);
mi_addsegment(WIDTH_CORE/2,0,WIDTH_CORE/2,THICK_CORE);

for i=0:SLOTS-1
    delta = SLOT_PITCH*i;
    mi_drawline(-slotTeethWidth/2+delta,0,-slotTeethWidth/2+delta,Hs2);
    mi_drawline(-slotTeethWidth/2+slotGap+delta,0,-slotTeethWidth/2+slotGap+delta,Hs2);
    mi_addsegment(-slotTeethWidth/2+delta,Hs2,-slotTeethWidth/2+delta+slotGap,Hs2);

end

for i=0:SLOTS-2
    delta=SLOT_PITCH*i;
    mi_addsegment(-slotTeethWidth/2+slotGap+delta,0,-slotTeethWidth/2+slotGap+delta+Bs1,0);
end

mi_addsegment(WIDTH_CORE/-2,0,-slotTeethWidth/2,0);
mi_addsegment(slotTeethWidth/2,0,WIDTH_CORE/2,0);

%Define Coil Currents
wt = 2*pi*freq;%*time;
phaseA = inputCurrent*exp(wt*j);
phaseB = inputCurrent*exp(wt*j+2*pi/3*j);
phaseC = inputCurrent*exp(wt*j+4*pi/3*j);
mi_addcircprop('WindingA',phaseA,1);
mi_addcircprop('WindingB',phaseB,1);
mi_addcircprop('WindingC',phaseC,1);

%Create and Label Coils
for i=0:SLOTS-1
   delta=SLOT_PITCH*i;

   bPhase = mod(i,3);
   tPhase = mod(i+1,3);
   bmodulo = 2*mod(i+1,2)-1;
   tmodulo = 2*mod(i+2,2)-1;
   bWinding = '';
   tWinding = '';

   if(bPhase==0)
       bWinding='WindingA';
   elseif(bPhase==1)
       bWinding='WindingB';
   elseif(bPhase==2)
       bWinding='WindingC';
   end

   if(tPhase==0)
       tWinding='WindingA';
   elseif(tPhase==1)
       tWinding='WindingB';
   elseif(tPhase==2)
       tWinding='WindingC';
   end
   %disp(bPhase)

   mi_drawline(-slotTeethWidth/2+delta,Hs2/2,-slotTeethWidth/2+slotGap+delta,Hs2/2);
   if(~(i==0||i==1))
        mi_addblocklabel(-slotTeethWidth/2+slotGap/2+delta,Hs2*3/4);
        mi_selectlabel(-slotTeethWidth/2+slotGap/2+delta,Hs2*3/4);
        mi_setblockprop(copperMaterial,1,0,tWinding,0,1,coilTurns*tmodulo);
        mi_clearselected;
   end
   if(~(i==SLOTS-1||i==SLOTS-2))
        mi_addblocklabel(-slotTeethWidth/2+slotGap/2+delta,Hs2*1/4);
        mi_selectlabel(-slotTeethWidth/2+slotGap/2+delta,Hs2*1/4);
        mi_setblockprop(copperMaterial,1,0,bWinding,0,1,coilTurns*bmodulo);
        mi_clearselected;
   end
end

%Fill remaining core gaps with air
mi_addblocklabel(-slotTeethWidth/2+slotGap/2,Hs2*3/4);
mi_selectlabel(-slotTeethWidth/2+slotGap/2,Hs2*3/4);
mi_addblocklabel(-slotTeethWidth/2+slotGap/2+SLOT_PITCH,Hs2*3/4);
mi_selectlabel(-slotTeethWidth/2+slotGap/2+SLOT_PITCH,Hs2*3/4);

mi_addblocklabel(slotTeethWidth/2-slotGap/2,Hs2*1/4);
mi_selectlabel(slotTeethWidth/2-slotGap/2,Hs2*1/4);
mi_addblocklabel(slotTeethWidth/2-slotGap/2-SLOT_PITCH,Hs2*1/4);
mi_selectlabel(slotTeethWidth/2-slotGap/2-SLOT_PITCH,Hs2*1/4);

mi_setblockprop(Air,1,0,'<None>',0,0,0);

%Select LIM Geometry and set to group 1
mi_selectrectangle(WIDTH_CORE/-2,0,WIDTH_CORE/2,THICK_CORE,4);
mi_setgroup(1);

%Label LIM Geometry
mi_addblocklabel(0,(Hs2+THICK_CORE)/2);
mi_selectlabel(0,(Hs2+THICK_CORE)/2);
mi_setblockprop(coreMaterial,1,0,'<None>',0,1,0);

%Create Space for Air Gap and Track
mi_selectgroup(1);
mi_movetranslate(0,GAP);

%Create and Label Air Gap
mi_addsegment(WIDTH_CORE/-2,GAP+trackThickness/2,WIDTH_CORE/2,GAP+trackThickness/2);
mi_selectrectangle(WIDTH_CORE/-2,trackThickness/2,WIDTH_CORE/2,GAP+trackThickness/2);
mi_setgroup(1);
%mi_addblocklabel(0,GAP/2);
%mi_selectlabel(0,GAP/2);
mi_setblockprop(Air,1,0,'<None>',0,1,0);

mi_selectgroup(1);
mi_mirror(WIDTH_CORE/-2,0,WIDTH_CORE/2,0);

%Create Track
mi_drawrectangle(WIDTH_CORE/-2,trackThickness/-2,WIDTH_CORE/2,trackThickness/2);
mi_selectrectangle(WIDTH_CORE/-2,trackThickness/-2,WIDTH_CORE/2,trackThickness/2);
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
mi_saveas('SimulationData\DLIMSimulations.fem');
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

end
