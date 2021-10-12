function [hysteresisLosses,totalLosses,lforcex,lforcey,wstforcex,wstforcey,phaseAvol,phaseBvol,phaseCvol,phaseAcur,phaseBcur,phaseCcur,phaseAfl,phaseBfl,phaseCfl] = run_simulation(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,width_core,thick_core,length,gap,slot_pitch,slots,Hs0,Hs01,Hs1,Hs2,Bs0,Bs1,Bs2,Rs,Layers,coil_pitch,end_ext,core_offset,simulationNumber,SAVE_BITMAP,RUN_SIM,HIDE_WINDOW)

%Define simulation/modeller units
unit = 'millimeters';

%Create new document and define problem solution
document_mode = 0;
if(~SAVE_BITMAP)
  if(HIDE_WINDOW)
    document_mode = 1;
  end
end

%Open FEMM and resize window
openfemm(document_mode);
main_resize(1000,590);

newdocument(0);

%Define problem setup
mi_probdef(freq,unit,'planar',1e-8,length,30);

%Get LIM Materials
Air = 'Air';
setup_materials(Air,copperMaterial,trackMaterial,coreMaterial)

%Define LIM Geometry Variables
sumSlotTeeth = slots*2+1;
slotGap = Bs2;
teethThickness = slot_pitch-Bs2;
slotTeethWidth = (slots-1)*slot_pitch+slotGap;
end_ext=end_ext-(width_core-slotTeethWidth)/2; 

%Define LIM Core Geometry
create_core(width_core,end_ext,thick_core,slot_pitch,slots,slotTeethWidth,slotGap,Hs2);

%Define winding phases
[phaseA,phaseB,phaseC] = define_excitations_td(inputCurrent,freq,0);

%Define winding arrangement
define_windings_ETH_Zurich_thesis(slots,slot_pitch,copperMaterial,Air,coilTurns,slotGap,slotTeethWidth,Hs2);

%Select LIM Geometry and set to group 1
mi_selectrectangle(width_core/-2-end_ext,0,width_core/2+end_ext,thick_core,4);
mi_setgroup(1);

%Label LIM Geometry
mi_addblocklabel(0,(Hs2+thick_core)/2);
mi_selectlabel(0,(Hs2+thick_core)/2);
mi_setblockprop(coreMaterial,1,0,'<None>',0,1,0);

%Create Space for Air Gap and Track
mi_selectgroup(1);
mi_movetranslate(0,gap);

%Create and Label Air Gap
mi_addsegment(width_core/-2-end_ext,gap,width_core/2+end_ext,gap);
mi_selectrectangle(width_core/-2-end_ext,trackThickness/2,width_core/2+end_ext,gap);
mi_setgroup(1);
%mi_addblocklabel(0,gap/2);
%mi_selectlabel(0,gap/2);
mi_setblockprop(Air,1,0,'<None>',0,1,0);

%Mirror one side to create DLIM
mi_selectgroup(1);
mi_mirror(width_core/-2-end_ext,0,width_core/2+end_ext,0);
mi_clearselected;

%Apply Core Offset
mi_selectgroup(1);
max_offset = gap-trackThickness/2; % maximum core offset
applied_offset = core_offset;
if(abs(core_offset)>max_offset)
  applied_offset = sign(core_offset)*max_offset*0.99; % ensure core does not contact track
end
mi_movetranslate(0,applied_offset);
mi_clearselected;

%Create Track
create_track(width_core,end_ext,trackThickness,trackMaterial);

if(RUN_SIM)
  %Final Adjustments and solve
  if(simulationNumber==-1)
    solve(thick_core,Air,append('DLIMSimulations.fem'));
  else 
    solve(thick_core,Air,append('..\SimulationData\temp_',num2str(simulationNumber),'.fem'));
  end
    
  %Analyze results
  mi_loadsolution;

  mo_selectblock(0,0);
  lforcex = mo_blockintegral(11);
  lforcey = mo_blockintegral(12);
  wstforcex = mo_blockintegral(18);
  wstforcey = mo_blockintegral(19);

  mo_clearblock;

  mo_selectblock(0,(Hs2+thick_core)/2+gap);
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
  if(SAVE_BITMAP)
    save_bitmap(width_core,end_ext,'DLIM.jpg')
  end
else
  mi_zoomnatural();
  hysteresisLosses=0;
  totalLosses=0;
  lforcex=0;
  lforcey=0;
  wstforcex=0;
  wstforcey=0;
  phaseAvol=0;
  phaseBvol=0;
  phaseCvol=0;
  phaseAcur=0;
  phaseBcur=0;
  phaseCcur=0;
  phaseAfl=0;
  phaseBfl=0;
  phaseCfl=0;
end

end
