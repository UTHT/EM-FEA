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
inputCurrent = 10;
freq = 60;
coilTurns = 360;
trackThickness = 8;
copperMaterial = '16 AWG';
coreMaterial = 'M-19 Steel';
trackMaterial = 'Aluminum, 6061-T6';
coreMaterialDensity = 7.7

%Define Simulation Specific Parameters
sumSlotTeeth = SLOTS*2+1; %Number of Teeth + Slots
slotGap = Bs2; %Width of an Individual Slot
teethThickness = SLOT_PITCH-Bs2;
slotTeethWidth = (SLOTS-1)*SLOT_PITCH+slotGap;
coilArea = slotGap*Hs2/2; %Area of coil for a single phase

%Define simulations Number
min_depth = 20;
max_depth = 50;
min_width = 20;
max_width = 60;
numSims = (max_depth-min_depth)*(max_width-min_width);

inputs = zeros(5,numSims);
outputs = zeros(6,numSims);
outputVoltage = zeros(3,numSims);
outputCurrent = zeros(3,numSims);
outputResistance = zeros(3,numSims);

for x=min_depth:max_depth
  for y=min_width:max_width
    Hs2=x;
    THICK_CORE=x+30;
    Bs1=y;
    WIDTH_CORE = y*(SLOTS+1)+20*(SLOTS);
    Volume = THICK_CORE/10*WIDTH_CORE/10*LENGTH/10-slotGap* ;
    Weight = Volume*coreMaterialDensity;

%     [losses,totalLosses,lforcex,lforcey,wstforcex,wstforcey,vA,vB,vC,cA,cB,cC] = DLIMSimulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH_CORE,THICK_CORE,LENGTH,GAP,SLOT_PITCH,SLOTS,Hs0,Hs01,Hs1,Hs2,Bs0,Bs1,Bs2,Rs,Layers,COIL_PITCH);
%     inputs(1,i)=inputCurrent; %Input Current in amps
%     inputs(2,i)=coilTurns; %Number of Coil Turns
%     inputs(3,i)=inputCurrent*coilTurns; %Ni
%     inputs(4,i)=Weight;%Weight of a single core (one side)
%     outputs(1,i)=wstforcex; %Weighted Stress Tensor Force on Track, x direction
%     outputs(2,i)=wstforcey; %Weighted Stress Tensor Force on Track, y direction
%     outputs(3,i)=lforcex; %Lorentz Force on Track, x direction
%     outputs(4,i)=lforcey; %Lorentz Force on Track, y direction
%     outputs(5,i)=losses; %Hysteresis Losses
%     outputs(6,i)=totalLosses; %Total Losses
%     outputVoltage(1,i)=vA; %Voltage of Phase A
%     outputVoltage(2,i)=vB; %Voltage of Phase B
%     outputVoltage(3,i)=vC; %Voltage of Phase C
%     outputCurrent(1,i)=cA; %Current of Phase A
%     outputCurrent(2,i)=cB; %Current of Phase B
%     outputCurrent(3,i)=cC; %Current of Phase C
%     outputResistance(1,i)=vA/cA; %Resistance of Phase A
%     outputResistance(2,i)=vB/cB; %Resistance of Phase B
%     outputResistance(3,i)=vC/cC; %Resistance of Phase C
%     outputResultX(x,y)=lforcex/Weight;%Force/Weight Ratio
%     outputResultY(x,y)=lforcey/Weight;
%     outputResultL(x,y)=losses;
    outputWeight(x,y)=Weight;
  end
end

%DLIMSimulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH_CORE,THICK_CORE,LENGTH,GAP,SLOT_PITCH,SLOTS,Hs0,Hs01,Hs1,Hs2,Bs0,Bs1,Bs2,Rs,Layers,COIL_PITCH)

save('geometry_results.mat','inputs','outputs','outputVoltage','outputCurrent','outputResistance');
