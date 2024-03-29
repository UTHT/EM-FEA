addpath("..");

%Simulation Description:
%Transient Simulations

%Set up environment (clear previous)
clc;
clear;

%Define LIM Parameters (Parallel to ANSYS rmXprt LinearMCore definition)
WIDTH_CORE = 370; %Core width in motion direction
THICK_CORE = 70; %Core thickness
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
coil_pitch = 2; %Coil Pitch measured in slots
end_ext = 0; % One-sided winding end extended length
SPAN_EXT = 20; %Core endlength
SEG_ANGLE = 15; %Deviation angle for slot arches
CORE_OFFSET = 0; %DLIM core midline deviation from track

%Simulation Flags
SAVE_BITMAP = true;
RUN_SIM = true;
HIDE_WINDOW = false; % only applies if SAVE_BITMAP = false

%Define Simulation Default Parameters
inputCurrent = 15;
freq = 15;
coilTurns = 308;
trackThickness = 8;
copperMaterial = '20 AWG';
trackMaterial = 'Aluminum, 6061-T6';
coreMaterial = 'M-19 Steel';

%Define Simulation Specific Parameters
sumSlotTeeth = SLOTS*2+1; %Number of Teeth + Slots
slotGap = SLOT_PITCH-Bs1; %Width of an Individual Slot
slotTeethWidth = (SLOTS-1)*SLOT_PITCH+slotGap;
coilArea = slotGap*Hs2/2; %Area of coil for a single phase
simulationNumber = -1;

%Simulation counter/duration Variables
totalTimeElapsed = 0;
tic
parfor angle=1:90
  singleSimTimeElapsed = 0;

  [losses,totalLosses,lforcex,lforcey,wstforcex,wstforcey,vA,vB,vC,cA,cB,cC,flA,flB,flC] = run_simulation(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH_CORE,THICK_CORE,LENGTH,GAP,SLOT_PITCH,SLOTS,Hs0,Hs01,Hs1,Hs2,Bs0,Bs1,Bs2,Rs,Layers,coil_pitch,end_ext,CORE_OFFSET,angle,SAVE_BITMAP,RUN_SIM,HIDE_WINDOW);
  outputWSTForcex(angle)=wstforcex; %Weighted Stress Tensor Force on Track, x direction
  outputWSTForcey(angle)=wstforcey; %Weighted Stress Tensor Force on Track, y direction
  outputLForcex(angle)=lforcex; %Lorentz Force on Track, x direction
  outputLForcey(angle)=lforcey; %Lorentz Force on Track, y direction
  outputHLosses(angle)=losses; %Hysteresis Losses
  outputTLosses(angle)=totalLosses; %Total Losses
  outputVoltageA(angle)=vA; %Voltage of Phase A
  outputVoltageB(angle)=vB; %Voltage of Phase B
  outputVoltageC(angle)=vC; %Voltage of Phase C
  outputCurrentA(angle)=cA; %Current of Phase A
  outputCurrentB(angle)=cB; %Current of Phase B
  outputCurrentC(angle)=cC; %Current of Phase C
  outputResistanceA(angle)=vA/cA; %Resistance of Phase A
  outputResistanceB(angle)=vB/cB; %Resistance of Phase B
  outputResistanceC(angle)=vC/cC; %Resistance of Phase C
  outputFluxLinkageA(angle)=flA;
  outputFluxLinkageB(angle)=flB;
  outputFluxLinkageC(angle)=flC;
  outputResultX(angle)=lforcex/Weight;%Force/Weight Ratio (x-direction)
  outputResultY(angle)=lforcey/Weight;%Force/Weight Ratio (y-direction)

  %save('transient_results.mat');
  disp(append("Simulation at angle ",num2str(angle)," completed."))
end
totalTimeElapsed = toc;
disp(append("Total Simulation Time: ",num2str(totalTimeElapsed),"seconds"))
