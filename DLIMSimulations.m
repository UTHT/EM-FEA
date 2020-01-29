unit = 'millimeters';

EnableBavg = false;
EnableBn = true;
EnableTorque = false;

%Define LIM Parameters (Parallel to ANSYS rmXprt LinearMCore definition)
WIDTH_CORE = 460;
THICK_CORE = 50;
LENGTH = 50;
GAP = 17.5;
SLOT_PITCH = 40;
SLOTS = 11;
Hs0 = 0;
Hs01 = 0;
Hs1 = 0;
Hs2 = 20;
Bs0 = 20;
Bs1 = 20;
Bs2 = 20;
Rs = 0;
Layers = 2;
COIL_PITCH = 2;

%Define Simulation Specific Parameters
inputCurrent = 200;
freq = 60;
coilTurns = 30;
trackThickness = 8;
copperMaterial = '10 AWG';
coreMaterial = '1010 Steel';
trackMaterial = 'Aluminum, 6061-T6';

%Open FEMM and resize window
openfemm(0);
main_resize(1000,590);

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
phaseA = inputCurrent*(cos(0)+sin(0)*j);
phaseB = inputCurrent*(-cos(60*pi/180)+sin(60*pi/180)*j);
phaseC = inputCurrent*(-cos(60*pi/180)-sin(60*pi/180)*j);
mi_addcircprop('WindingA',phaseA,1);
mi_addcircprop('WindingB',phaseB,1);
mi_addcircprop('WindingC',phaseC,1);

%Create and Label Coils
for i=0:SLOTS-1
   delta=SLOT_PITCH*i;
   
   bPhase = mod(i,3);
   tPhase = mod(i+1,3);
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
        mi_setblockprop(copperMaterial,1,0,tWinding,0,1,-coilTurns);
        mi_clearselected;
   end
   if(~(i==SLOTS-1||i==SLOTS-2))
        mi_addblocklabel(-slotTeethWidth/2+slotGap/2+delta,Hs2*1/4);
        mi_selectlabel(-slotTeethWidth/2+slotGap/2+delta,Hs2*1/4);  
        mi_setblockprop(copperMaterial,1,0,bWinding,0,1,coilTurns);
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
mi_movetranslate(0,GAP+trackThickness/2);

%Create and Label Air Gap
mi_drawrectangle(WIDTH_CORE/-2,trackThickness/2,WIDTH_CORE/2,GAP+trackThickness/2);
mi_selectrectangle(WIDTH_CORE/-2,trackThickness/2,WIDTH_CORE/2,GAP+trackThickness/2);
mi_setgroup(1);
mi_addblocklabel(0,GAP/2);
mi_selectlabel(0,GAP/2);
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
mi_saveas('DLIMSimulations.fem');
mi_analyze;
mi_loadsolution;