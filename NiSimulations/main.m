%Define LIM Parameters (Parallel to ANSYS rmXprt LinearMCore definition)
WIDTH_CORE = 370; %Core width in motion direction
THICK_CORE = 60; %Core thickness
LENGTH = 50; %Core length
GAP = 6; %Gap between core and xy plane (or 1/2 of air gap)
SLOT_PITCH = 40; %Distance between two slots
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
coilArea = slotGap*Hs2/2; %Area of coil for a single phase

%Define simulations Number
numSims = 100;
startVal = 1;

parfor x=startVal:numSims+startVal
  coilTurns = 5*x;
  tic
  %WIDTH_CORE = Bs2*(SLOTS)+20*(SLOTS-1);
  Volume = THICK_CORE/10*WIDTH_CORE/10*LENGTH/10-Bs2/10*Hs2/10*LENGTH/10*(SLOTS); %Volume of DLIM in cm3
  Weight = Volume*coreMaterialDensity*2; %Weight of DLIM Core in g
  simulationNumber = x;

  inputHs2(x)=Hs2;
  inputDepth(x)=THICK_CORE;
  inputBs2(x)=Bs2;
  inputWidth(x)=WIDTH_CORE;
  inputEndExt(x)=END_EXT;
  inputNi(x)=inputCurrent*coilTurns; %Ni
  inputWeight(x)=Weight; %Weight of a single core (one side)
  inputVolume(x)=Volume;
  inputCoilArea(x)=coilArea;

  [losses,totalLosses,lforcex,lforcey,wstforcex,wstforcey,vA,vB,vC,cA,cB,cC,flA,flB,flC] = DLIMSimulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH_CORE,THICK_CORE,LENGTH,GAP,SLOT_PITCH,SLOTS,Hs0,Hs01,Hs1,Hs2,Bs0,Bs1,Bs2,Rs,Layers,COIL_PITCH,END_EXT,simulationNumber);
  outputWSTForcex(x)=wstforcex; %Weighted Stress Tensor Force on Track, x direction
  outputWSTForcey(x)=wstforcey; %Weighted Stress Tensor Force on Track, y direction
  outputLForcex(x)=lforcex; %Lorentz Force on Track, x direction
  outputLForcey(x)=lforcey; %Lorentz Force on Track, y direction
  outputHLosses(x)=losses; %Hysteresis Losses
  outputTLosses(x)=totalLosses; %Total Losses
  outputVoltageA(x)=vA; %Voltage of Phase A
  outputVoltageB(x)=vB; %Voltage of Phase B
  outputVoltageC(x)=vC; %Voltage of Phase C
  outputCurrentA(x)=cA; %Current of Phase A
  outputCurrentB(x)=cB; %Current of Phase B
  outputCurrentC(x)=cC; %Current of Phase C
  outputResistanceA(x)=vA/cA; %Resistance of Phase A
  outputResistanceB(x)=vB/cB; %Resistance of Phase B
  outputResistanceC(x)=vC/cC; %Resistance of Phase C
  outputFluxLinkageA(x)=flA;
  outputFluxLinkageB(x)=flB;
  outputFluxLinkageC(x)=flC;
  outputResultX(x)=lforcex/Weight;%Force/Weight Ratio (x-direction)
  outputResultY(x)=lforcey/Weight;%Force/Weight Ratio (y-direction)

  singleSimTimeElapsed=toc;

  disp(append("Simulation Number ",num2str(simulationNumber)," completed in ",num2str(singleSimTimeElapsed)," seconds with parameters NI =",num2str(inputCurrent*coilTurns)))

end

save('results.mat');

%DLIMSimulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH_CORE,THICK_CORE,LENGTH,GAP,SLOT_PITCH,SLOTS,Hs0,Hs01,Hs1,Hs2,Bs0,Bs1,Bs2,Rs,Layers,COIL_PITCH)
