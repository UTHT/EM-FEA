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
copperMaterial = '16 AWG';
coreMaterial = 'M-19 Steel';%'1010 Steel';
trackMaterial = 'Aluminum, 6061-T6';

%Define Simulation Specific Parameters
sumSlotTeeth = SLOTS*2+1; %Number of Teeth + Slots
slotGap = SLOT_PITCH-Bs1; %Width of an Individual Slot
slotTeethWidth = (SLOTS-1)*SLOT_PITCH+slotGap;
coilArea = slotGap*Hs2/2; %Area of coil for a single phase

%Define simulations Number
numSims = 1000;
startVal = 5;

inputs = zeros(1,numSims);
outputs = zeros(6,numSims);
outputVoltage = zeros(3,numSims);
outputCurrent = zeros(3,numSims);
outputResistance = zeros(3,numSims);

for index=startVal:numSims+startVal
  inputCurrent = index*2;
  i=index-startVal+1;
  disp(inputCurrent);
  disp(i);
  [losses,totalLosses,lforcex,lforcey,wstforcex,wstforcey,vA,vB,vC,cA,cB,cC] = DLIMSimulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH_CORE,THICK_CORE,LENGTH,GAP,SLOT_PITCH,SLOTS,Hs0,Hs01,Hs1,Hs2,Bs0,Bs1,Bs2,Rs,Layers,COIL_PITCH);
  inputs(1,i)=inputCurrent; %Input Current in amps
  outputs(1,i)=wstforcex; %Weighted Stress Tensor Force on Track, x direction
  outputs(2,i)=wstforcey; %Weighted Stress Tensor Force on Track, y direction
  outputs(3,i)=lforcex; %Lorentz Force on Track, x direction
  outputs(4,i)=lforcey; %Lorentz Force on Track, y direction
  outputs(5,i)=losses; %Hysteresis Losses
  outputs(6,i)=totalLosses; %Total Losses
  outputVoltage(1,i)=vA; %Voltage of Phase A
  outputVoltage(2,i)=vB; %Voltage of Phase B
  outputVoltage(3,i)=vC; %Voltage of Phase C
  outputCurrent(1,i)=cA; %Current of Phase A
  outputCurrent(2,i)=cB; %Current of Phase B
  outputCurrent(3,i)=cC; %Current of Phase C
  outputResistance(1,i)=vA/cA; %Resistance of Phase A
  outputResistance(2,i)=vB/cB; %Resistance of Phase B
  outputResistance(3,i)=vC/cC; %Resistance of Phase C
end

save('params.mat','inputs','outputs','outputVoltage','outputCurrent','outputResistance');

%DLIMSimulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH_CORE,THICK_CORE,LENGTH,GAP,SLOT_PITCH,SLOTS,Hs0,Hs01,Hs1,Hs2,Bs0,Bs1,Bs2,Rs,Layers,COIL_PITCH)
