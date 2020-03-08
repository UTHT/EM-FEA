%Simulation Description:
%Output Force,Losses vs Slot Depth (Hs2) and Slot Gap Width (Bs2)
%Constant slot area at 400mm^2


%Define LIM Parameters (Parallel to ANSYS rmXprt LinearMCore definition)
WIDTH_CORE = 370; %Core width in motion direction
THICK_CORE = 60; %Core thickness
LENGTH = 50; %Core length
GAP = 6; %Gap between core and xy plane (or 1/2 of air gap)
SLOT_PITCH = 30; %Distance between two slots
SLOTS = 11; %Number of slots
Hs0 = 0; %Slot opening height
Hs01 = 0; %Slot closed bridge height
Hs1 = 0; %Slot wedge height
Hs2 = 40; %Slot body height (Height of teeth gap)
Bs0 = 20; %Slot opening width
Bs1 = 20; %Slot wedge maximum Width
Bs2 = 10; %Slot body bottom width
Rs = 0; %Slot body bottom fillet
Layers = 2; %Number of winding layers
COIL_PITCH = 2; %Coil Pitch measured in slots
END_EXT = 30; %One-sided winding end extended length
SPAN_EXT = 20; %Axial length of winding end span
SEG_ANGLE = 15; %Deviation angle for slot arches

%Define Simulation Default Parameters
inputCurrent = 10;
freq = 15;
coilTurns = 310;
trackThickness = 8;
copperMaterial = '20 AWG';
trackMaterial = 'Aluminum, 6061-T6';
coreMaterial = 'M-19 Steel';
coreMaterialDensity = 7.7;


%Define Simulation Specific Parameters
sumSlotTeeth = SLOTS*2+1; %Number of Teeth + Slots
slotGap = Bs2; %Width of an Individual Slot
teethThickness = SLOT_PITCH-Bs2;
slotTeethWidth = (SLOTS-1)*SLOT_PITCH+slotGap;
coilArea = 400; %Area of coil for a single slot

%Define simulations bounds
min_freq = 0;
max_freq = 150;

%Simulation counter/duration Variables
totalTimeElapsed = 0;
singleSimTimeElapsed = 0;
simulationNumber = 1;

parfor z=min_freq+1:max_freq+1
  freq=z*2;
  tic
  coilArea=Bs2*Hs2/2;
  SLOT_PITCH=teethThickness+Bs2;
  WIDTH_CORE = Bs2*(SLOTS)+teethThickness*(SLOTS-1);
  Volume = THICK_CORE/10*(WIDTH_CORE+2*END_EXT)/10*LENGTH/10-Bs2/10*Hs2/10*LENGTH/10*(SLOTS); %Volume of DLIM in cm3
  Weight = Volume*coreMaterialDensity*2; %Weight of DLIM Core in g
  POLE_PITCH=2*SLOT_PITCH;
  simulationNumber=z;

  disp(append("starting Simulation Number ",num2str(simulationNumber),"  with parameters Hs2=",num2str(Hs2),", Bs2=",num2str(Bs2)))

  inputHs2(z)=Hs2;
  inputDepth(z)=THICK_CORE;
  inputBs2(z)=Bs2;
  inputWidth(z)=WIDTH_CORE;
  inputNi(z)=inputCurrent*coilTurns; %Ni
  inputWeight(z)=Weight; %Weight of a single core (one side)
  inputVolume(z)=Volume;
  inputCoilArea(z)=coilArea;

  syncSpeed(z) = 2*POLE_PITCH*freq;

  [losses,totalLosses,lforcex,lforcey,wstforcex,wstforcey,vA,vB,vC,cA,cB,cC] = DLIMSimulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH_CORE,THICK_CORE,LENGTH,GAP,SLOT_PITCH,SLOTS,Hs0,Hs01,Hs1,Hs2,Bs0,Bs1,Bs2,Rs,Layers,COIL_PITCH,END_EXT,simulationNumber);
  outputWSTForcex(z)=wstforcex; %Weighted Stress Tensor Force on Track, x direction
  outputWSTForcey(z)=wstforcey; %Weighted Stress Tensor Force on Track, y direction
  outputLForcex(z)=lforcex; %Lorentz Force on Track, x direction
  outputLForcey(z)=lforcey; %Lorentz Force on Track, y direction
  outputHLosses(z)=losses; %Hysteresis Losses
  outputTLosses(z)=totalLosses; %Total Losses
  outputVoltageA(z)=vA; %Voltage of Phase A
  outputVoltageB(z)=vB; %Voltage of Phase B
  outputVoltageC(z)=vC; %Voltage of Phase C
  outputCurrentA(z)=cA; %Current of Phase A
  outputCurrentB(z)=cB; %Current of Phase B
  outputCurrentC(z)=cC; %Current of Phase C
  outputResistanceA(z)=vA/cA; %Resistance of Phase A
  outputResistanceB(z)=vB/cB; %Resistance of Phase B
  outputResistanceC(z)=vC/cC; %Resistance of Phase C
  outputResultX(z)=lforcex/Weight;%Force/Weight Ratio (x-direction)
  outputResultY(z)=lforcey/Weight;%Force/Weight Ratio (y-direction)
  %save('geometry_results.mat');

  singleSimTimeElapsed=toc;
  disp(append("Simulation Number ",num2str(simulationNumber)," completed in ",num2str(singleSimTimeElapsed)," seconds with parameters Hs2=",num2str(Hs2),", Bs2=",num2str(Bs2)))
  simulationNumber=simulationNumber+1;
  totalTimeElapsed = totalTimeElapsed+singleSimTimeElapsed;
end
disp(append("Total Simulation Time: ",num2str(totalTimeElapsed),"seconds"))
save('final_results.mat');
%DLIMSimulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH_CORE,THICK_CORE,LENGTH,GAP,SLOT_PITCH,SLOTS,Hs0,Hs01,Hs1,Hs2,Bs0,Bs1,Bs2,Rs,Layers,COIL_PITCH)
