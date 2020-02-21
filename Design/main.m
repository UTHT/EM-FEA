%Simulation Description:
%All Parameters vs Core Thickness (THICK_CORE) and Core Width (WIDTH_CORE/END_EXT)
load('geometry_results.mat')


%Define LIM Parameters (Parallel to ANSYS rmXprt LinearMCore definition)
WIDTH_CORE = 460; %Core width in motion direction
THICK_CORE = 50; %Core thickness
LENGTH = 50; %Core length
GAP = 17.5; %Gap between core and xy plane (or 1/2 of air gap)
SLOT_PITCH = 40; %Distance between two slots
SLOTS = 11; %Number of slots
Hs0 = 0; %Slot opening height
Hs01 = 0; %Slot closed bridge height
Hs1 = 0; %Slot wedge height
Hs2 = 20; %Slot body height (Height of teeth gap)
Bs0 = 20; %Slot opening width
Bs1 = 20; %Slot wedge maximum Width
Bs2 = 20; %Slot body bottom width
Rs = 0; %Slot body bottom fillet
Layers = 2; %Number of winding layers
COIL_PITCH = 2; %Coil Pitch measured in slots
END_EXT = 0; %One-sided winding end extended length
SPAN_EXT = 20; %Axial length of winding end span
SEG_ANGLE = 15; %Deviation angle for slot arches

%Define Simulation Default Parameters
inputCurrent = 10;
freq = 60;
coilTurns = 360;
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

%Define Simulation Specific Parameters
sumSlotTeeth = SLOTS*2+1; %Number of Teeth + Slots
slotGap = SLOT_PITCH-Bs1; %Width of an Individual Slot
slotTeethWidth = (SLOTS-1)*SLOT_PITCH+slotGap;
coilArea = slotGap*Hs2/2; %Area of coil for a single phase

%Define simulations bounds
min_thickness = 1;
max_thickness = 50;
min_width = 1;
max_width = 40;

%Simulation counter/duration Variables
totalTimeElapsed = 0;
singleSimTimeElapsed = 0;
simulationNumber = 1;

%outputWSTForcex=imresize(outputWSTForcex,[max_thickness,max_width]  )

parfor x=min_thickness:max_thickness

  for y=min_width:max_width
    simulationNumber = y+(x-1)*max_thickness
    tic
    Hs2=40;
    THICK_CORE=x+Hs2;
    Bs2=10;
    coilArea=Bs2*Hs2;
    SLOT_PITCH=teethThickness+Bs2;
    END_EXT = y;
    WIDTH_CORE = Bs2*(SLOTS)+20*(SLOTS-1)+2*END_EXT;
    Volume = THICK_CORE/10*WIDTH_CORE/10*LENGTH/10-Bs2/10*Hs2/10*LENGTH/10*(SLOTS); %Volume of DLIM in cm3
    Weight = Volume*coreMaterialDensity*2; %Weight of DLIM Core in g

    inputHs2(x,y)=Hs2;
    inputDepth(x,y)=THICK_CORE;
    inputBs2(x,y)=Bs2;
    inputWidth(x,y)=WIDTH_CORE;
    inputEndExt(x,y)=END_EXT;
    inputNi(x,y)=inputCurrent*coilTurns; %Ni
    inputWeight(x,y)=Weight; %Weight of a single core (one side)
    inputVolume(x,y)=Volume;
    inputCoilArea(x,y)=coilArea;

    %if (outputWSTForcex(x,y)==0)

    [losses,totalLosses,lforcex,lforcey,wstforcex,wstforcey,vA,vB,vC,cA,cB,cC,flA,flB,flC] = DLIMSimulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH_CORE,THICK_CORE,LENGTH,GAP,SLOT_PITCH,SLOTS,Hs0,Hs01,Hs1,Hs2,Bs0,Bs1,Bs2,Rs,Layers,COIL_PITCH,simulationNumber);
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
    outputFluxLinkageA(x,y)=flA;
    outputFluxLinkageB(x,y)=flB;
    outputFluxLinkageC(x,y)=flC;
    outputResultX(x,y)=lforcex/Weight;%Force/Weight Ratio (x-direction)
    outputResultY(x,y)=lforcey/Weight;%Force/Weight Ratio (y-direction)
    %save('geometry_results.mat');

    singleSimTimeElapsed=toc;
    disp(append("Simulation Number ",num2str(simulationNumber)," completed in ",num2str(singleSimTimeElapsed)," seconds with parameters THICK_CORE=",num2str(THICK_CORE),"WIDTH_CORE=",num2str(WIDTH_CORE)))

    %else
    %  disp(sprintf("Skipping Simulation Number %d with parameters THICK_CORE=%d WIDTH_CORE=%d",(simulationNumber),THICK_CORE,WIDTH_CORE));
    %end

    simulationNumber=simulationNumber+1;
    totalTimeElapsed = totalTimeElapsed+singleSimTimeElapsed;
  end
end
disp(append("Total Simulation Time: ",num2str(totalTimeElapsed),"seconds"))

save('geometry_results.mat');
