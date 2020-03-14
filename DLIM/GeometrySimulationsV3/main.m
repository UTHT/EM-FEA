%Simulation Description:
%Output Force,Losses vs Slot Depth (Hs2) and Slot Gap Width (Bs2)
%Constant slot area at 400mm^2


%Define LIM Parameters (Parallel to ANSYS rmXprt LinearMCore definition)
WIDTH_CORE = 460;
THICK_CORE = 50;
LENGTH = 50;
GAP = 6;
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
END_EXT = 30;

%Define Simulation Default Parameters
inputCurrent = 10;
freq = 10;
coilTurns = 310;
trackThickness = 8;
copperMaterial = '16 AWG';
coreMaterial = 'M-19 Steel';
trackMaterial = 'Aluminum, 6061-T6';
coreMaterialDensity = 7.7;

%Define Simulation Specific Parameters
sumSlotTeeth = SLOTS*2+1; %Number of Teeth + Slots
slotGap = Bs2; %Width of an Individual Slot
teethThickness = 20;
slotTeethWidth = (SLOTS-1)*SLOT_PITCH+slotGap;
coilArea = 400; %Area of coil for a single slot

%Define simulations bounds
min_depth = 5;
max_depth = 60;

%Simulation counter/duration Variables
totalTimeElapsed = 0;
singleSimTimeElapsed = 0;
simulationNumber = 1;

save('frequency_variant.mat');

parfor z=1:10
  freq=z*15;
  coilArea=400;
  for x=min_depth:max_depth
    y=int64(coilArea/x);
    tic
    Bs2=x;
    THICK_CORE=y+30;
    Hs2=y;
    coilArea=Bs2*Hs2;
    SLOT_PITCH=teethThickness+Bs2;
    WIDTH_CORE = Bs2*(SLOTS)+teethThickness*(SLOTS-1);
    Volume = THICK_CORE/10*(WIDTH_CORE+2*END_EXT)/10*LENGTH/10-Bs2/10*Hs2/10*LENGTH/10*(SLOTS); %Volume of DLIM in cm3
    Weight = Volume*coreMaterialDensity*2; %Weight of DLIM Core in g
    POLE_PITCH=2*SLOT_PITCH;
    simulationNumber=x+z*60;

    disp(append("starting Simulation Number ",num2str(simulationNumber),"  with parameters Hs2=",num2str(Hs2),", Bs2=",num2str(Bs2)))

    inputHs2(z,x)=Hs2;
    inputDepth(z,x)=THICK_CORE;
    inputBs2(z,x)=Bs2;
    inputWidth(z,x)=WIDTH_CORE;
    inputNi(z,x)=inputCurrent*coilTurns; %Ni
    inputWeight(z,x)=Weight; %Weight of a single core (one side)
    inputVolume(z,x)=Volume;
    inputCoilArea(z,x)=coilArea;

    syncSpeed(z,x) = 2*POLE_PITCH*freq;

    [losses,totalLosses,lforcex,lforcey,wstforcex,wstforcey,vA,vB,vC,cA,cB,cC] = DLIMSimulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH_CORE,THICK_CORE,LENGTH,GAP,SLOT_PITCH,SLOTS,Hs0,Hs01,Hs1,Hs2,Bs0,Bs1,Bs2,Rs,Layers,COIL_PITCH,END_EXT,simulationNumber);
    outputWSTForcex(z,x)=wstforcex; %Weighted Stress Tensor Force on Track, x direction
    outputWSTForcey(z,x)=wstforcey; %Weighted Stress Tensor Force on Track, y direction
    outputLForcex(z,x)=lforcex; %Lorentz Force on Track, x direction
    outputLForcey(z,x)=lforcey; %Lorentz Force on Track, y direction
    outputHLosses(z,x)=losses; %Hysteresis Losses
    outputTLosses(z,x)=totalLosses; %Total Losses
    outputVoltageA(z,x)=vA; %Voltage of Phase A
    outputVoltageB(z,x)=vB; %Voltage of Phase B
    outputVoltageC(z,x)=vC; %Voltage of Phase C
    outputCurrentA(z,x)=cA; %Current of Phase A
    outputCurrentB(z,x)=cB; %Current of Phase B
    outputCurrentC(z,x)=cC; %Current of Phase C
    outputResistanceA(z,x)=vA/cA; %Resistance of Phase A
    outputResistanceB(z,x)=vB/cB; %Resistance of Phase B
    outputResistanceC(z,x)=vC/cC; %Resistance of Phase C
    outputResultX(z,x)=lforcex/Weight;%Force/Weight Ratio (x-direction)
    outputResultY(z,x)=lforcey/Weight;%Force/Weight Ratio (y-direction)
    %save('geometry_results.mat');

    singleSimTimeElapsed=toc;
    disp(append("Simulation Number ",num2str(simulationNumber)," completed in ",num2str(singleSimTimeElapsed)," seconds with parameters Hs2=",num2str(Hs2),", Bs2=",num2str(Bs2)))
    simulationNumber=simulationNumber+1;
    totalTimeElapsed = totalTimeElapsed+singleSimTimeElapsed;

  end
  %save(sprintf('f%03d.mat',freq));
end
disp(append("Total Simulation Time: ",num2str(totalTimeElapsed),"seconds"))
save('frequency_variant.mat');
%DLIMSimulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH_CORE,THICK_CORE,LENGTH,GAP,SLOT_PITCH,SLOTS,Hs0,Hs01,Hs1,Hs2,Bs0,Bs1,Bs2,Rs,Layers,COIL_PITCH)
