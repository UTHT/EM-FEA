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

%Define Simulation Default Parameters
inputCurrent = 200;
freq = 60;
coilTurns = 30;
trackThickness = 8;
copperMaterial = '10 AWG';
coreMaterial = 'M-19 Steel';%'1010 Steel';
trackMaterial = 'Aluminum, 6061-T6';

%Define Simulation Specific Parameters

sumSlotTeeth = SLOTS*2+1; %Number of Teeth + Slots
slotGap = SLOT_PITCH-Bs1; %Width of an Individual Slot
slotTeethWidth = (SLOTS-1)*SLOT_PITCH+slotGap;
coilArea = slotGap*Hs2/2; %Area of coil for a single phase

outputs = zeros(5,34);
outputVoltage = zeros(3,34);
outputCurrent = zeros(3,34);

for i=5:2000
  inputCurrent = i*2
  [losses,lforcex,lforcey,wstforcex,wstforcey,vA,vB,vC,cA,cB,cC] = DLIMSimulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH_CORE,THICK_CORE,LENGTH,GAP,SLOT_PITCH,SLOTS,Hs0,Hs01,Hs1,Hs2,Bs0,Bs1,Bs2,Rs,Layers,COIL_PITCH)
  outputs(1,i)=wstforcex;
  outputs(2,i)=wstforcey;
  outputs(3,i)=lforcex;
  outputs(4,i)=lforcey
  outputs(5,i)=losses;
  outputVoltage(1,i)=vA;
  outputVoltage(2,i)=vB;
  outputVoltage(3,i)=vC;
  outputCurrent(1,i)=cA;
  outputCurrent(2,i)=cB;
  outputCurrent(3,i)=cC;
end



%DLIMSimulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH_CORE,THICK_CORE,LENGTH,GAP,SLOT_PITCH,SLOTS,Hs0,Hs01,Hs1,Hs2,Bs0,Bs1,Bs2,Rs,Layers,COIL_PITCH)
