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
coreMaterialDensity = 7.7;

%Define Simulation Specific Parameters
sumSlotTeeth = SLOTS*2+1; %Number of Teeth + Slots
slotGap = Bs2; %Width of an Individual Slot
teethThickness = SLOT_PITCH-Bs2;
slotTeethWidth = (SLOTS-1)*SLOT_PITCH+slotGap;
coilArea = slotGap*Hs2/2; %Area of coil for a single phase

%Define simulations bounds
min_depth = 1;
max_depth = 50;
min_width = 1;
max_width = 60;
numSims = (max_depth-min_depth)*(max_width-min_width);

for x=min_depth:max_depth
  for y=min_width:max_width
    disp(x);
    disp(y);
    Hs2=x;
    THICK_CORE=x+30;
    Bs2=y;
    SLOT_PITCH=teethThickness+Bs2;
    WIDTH_CORE = y*(SLOTS)+20*(SLOTS+1);
    Volume = THICK_CORE/10*WIDTH_CORE/10*LENGTH/10-Bs2/10*Hs2/10*LENGTH/10*(SLOTS); %Volume of DLIM in cm3
    Weight = Volume*coreMaterialDensity*2; %Weight of DLIM Core in g

    inputHs2(x,y)=Hs2;
    inputDepth(x,y)=THICK_CORE;
    inputBs2(x,y)=Bs2;
    inputWidth(x,y)=WIDTH_CORE;
    inputNi(x,y)=inputCurrent*coilTurns; %Ni
    inputWeight(x,y)=Weight; %Weight of a single core (one side)
    inputVolume(x,y)=Volume;

    [losses,totalLosses,lforcex,lforcey,wstforcex,wstforcey,vA,vB,vC,cA,cB,cC] = DLIMSimulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH_CORE,THICK_CORE,LENGTH,GAP,SLOT_PITCH,SLOTS,Hs0,Hs01,Hs1,Hs2,Bs0,Bs1,Bs2,Rs,Layers,COIL_PITCH);
    outputWSTForcex(x,y)=wstforcex; %Weighted Stress Tensor Force on Track, x direction
    outputWSTForcey(x,y)=wstforcey; %Weighted Stress Tensor Force on Track, y direction
    outputLForcex(x,y)=lforcex; %Lorentz Force on Track, x direction
    outputLForcey(x,y)=lforcey; %Lorentz Force on Track, y direction
    outputHLosses(x,y)=losses; %Hysteresis Losses
    outputTLosses(x,y)=totalLosses; %Total Losses
    outputVoltageA(x,y)=vA; %Voltage of Phase A
    outputVoltageB(x,y)=vB; %Voltage of Phase B
    outputVoltageC(x,y)=vC; %Voltage of Phase C
    outputCurrentA(x,y)=cA; %Current of Phase A
    outputCurrentB(x,y)=cB; %Current of Phase B
    outputCurrentC(x,y)=cC; %Current of Phase C
    outputResistanceA(x,y)=vA/cA; %Resistance of Phase A
    outputResistanceB(x,y)=vB/cB; %Resistance of Phase B
    outputResistanceC(x,y)=vC/cC; %Resistance of Phase C
    outputResultX(x,y)=lforcex/Weight;%Force/Weight Ratio (x-direction)
    outputResultY(x,y)=lforcey/Weight;%Force/Weight Ratio (y-direction)
    save('geometry_results.mat');
  end
end

%DLIMSimulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH_CORE,THICK_CORE,LENGTH,GAP,SLOT_PITCH,SLOTS,Hs0,Hs01,Hs1,Hs2,Bs0,Bs1,Bs2,Rs,Layers,COIL_PITCH)
