function [hysteresisLosses,totalLosses,lforcex,lforcey,wstforcex,wstforcey,phaseAvol,phaseBvol,phaseCvol,phaseAcur,phaseBcur,phaseCcur,phaseAfl,phaseBfl,phaseCfl] = run_simulation(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH_CORE,THICK_CORE,LENGTH,GAP,SLOT_PITCH,SLOTS,Hs0,Hs01,Hs1,Hs2,Bs0,Bs1,Bs2,Rs,Layers,COIL_PITCH,END_EXT)

%Define simulation/modeller units
unit = 'millimeters';

%Open FEMM and resize window
openfemm(0);
main_resize(1000,590);

%Create new document and define problem solution
newdocument(0);

%Define problem setup
mi_probdef(freq,unit,'planar',1e-8,LENGTH,30);

%Get LIM Materials
Air = 'Air';
setup_materials(Air,copperMaterial,trackMaterial,coreMaterial)

%Define LIM Geometry Variables
sumSlotTeeth = SLOTS*2+1;
slotGap = Bs2;
teethThickness = SLOT_PITCH-Bs2;
slotTeethWidth = (SLOTS-1)*SLOT_PITCH+slotGap;
END_EXT=END_EXT+slotGap;

%Define LIM Core Geometry
create_core(WIDTH_CORE,END_EXT,THICK_CORE,SLOT_PITCH,SLOTS,slotTeethWidth,slotGap,Hs2);

%Define winding phases
[phaseA,phaseB,phaseC] = define_excitations_td(inputCurrent,freq,0);

%Define winding arrangement
define_windings_2ladw(SLOTS,SLOT_PITCH,copperMaterial,Air,coilTurns,slotGap,slotTeethWidth,Hs2);

%Select LIM Geometry and set to group 1
mi_selectrectangle(WIDTH_CORE/-2-END_EXT,0,WIDTH_CORE/2+END_EXT,THICK_CORE,4);
mi_setgroup(1);

%Label LIM Geometry
mi_addblocklabel(0,(Hs2+THICK_CORE)/2);
mi_selectlabel(0,(Hs2+THICK_CORE)/2);
mi_setblockprop(coreMaterial,1,0,'<None>',0,1,0);

%Create Space for Air Gap and Track
mi_selectgroup(1);
mi_movetranslate(0,GAP);

%Create and Label Air Gap
mi_addsegment(WIDTH_CORE/-2-END_EXT,GAP,WIDTH_CORE/2+END_EXT,GAP);
mi_selectrectangle(WIDTH_CORE/-2-END_EXT,trackThickness/2,WIDTH_CORE/2+END_EXT,GAP);
mi_setgroup(1);
%mi_addblocklabel(0,GAP/2);
%mi_selectlabel(0,GAP/2);
mi_setblockprop(Air,1,0,'<None>',0,1,0);

%Mirror one side to create DLIM
mi_selectgroup(1);
mi_mirror(WIDTH_CORE/-2-END_EXT,0,WIDTH_CORE/2+END_EXT,0);

%Create Track
create_track(WIDTH_CORE,END_EXT,trackThickness,trackMaterial);

%Final Adjustments and solve
solve(THICK_CORE,Air,'DLIMSimulations.fem');

%Analyze results
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
save_bitmap(WIDTH_CORE,END_EXT,'DLIM.jpg')

end
