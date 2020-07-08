  %Define LIM Parameters (Parallel to ANSYS rmXprt LinearMCore definition)
WIDTH_CORE = 500; %Core width in motion direction
THICK_CORE = 60; %Core thickness
LENGTH = 50; %Core length
GAP = 6; %Gap between core and xy plane (or 1/2 of air gap)
SLOT_PITCH = 60; %Distance between two slots
SLOTS = 12; %Number of slots
Hs0 = 0; %Slot opening height
Hs01 = 0; %Slot closed bridge height
Hs1 = 0; %Slot wedge height
Hs2 = 40; %Slot body height (Height of teeth gap)
Bs0 = 20; %Slot opening width
Bs1 = 20; %Slot wedge maximum Width
Bs2 = 20; %Slot body bottom width
Rs = 0; %Slot body bottom fillet
Layers = 2; %Number of winding layers
COIL_PITCH = 2; %Coil Pitch measured in slots
END_EXT = 30; %One-sided winding end extended length
SPAN_EXT = 20; %Axial length of winding end span
SEG_ANGLE = 15; %Deviation angle for slot arches

%LIM Parameter generation from slot_pitch
teeth_thickness = 20;
slot_thickness = 40;
core_endlength = 30;
coil_thickness = Hs2/2;
SLOT_PITCH = teeth_thickness+slot_thickness;
Bs2 = slot_thickness;
WIDTH_CORE=SLOT_PITCH*(SLOTS-1)+slot_thickness;
pole_pitch = SLOTS*SLOT_PITCH;

%Define Simulation Default Parameters
inputCurrent = 10;
freq = 15;
coilTurns = 310;
trackThickness = 8;
copperMaterial = '20 AWG';
trackMaterial = 'Aluminum, 6061-T6';
coreMaterial = 'M-19 Steel';
coreMaterialDensity = 7.7;

%Define Optimization Specific Parameters
sync_speed = 2*pole_pitch*freq;
G_factor_prop = pole_pitch^2*freq/GAP;

%Define Simulation Specific Parameters
sumSlotTeeth = SLOTS*2+1; %Number of Teeth + Slots
slotGap = SLOT_PITCH-Bs1; %Width of an Individual Slot
slotTeethWidth = (SLOTS-1)*SLOT_PITCH+slotGap;
coilArea = slotGap*Hs2/2; %Area of coil for a single phase
totalTimeElapsed = 0;

%Define Simulation bounds
min_sp = 40;
max_sp = 400;
delta_sp = 1;
sp_values = min_sp:delta_sp:max_sp;
num_sp = 361;

min_fq = 15;
max_fq = 300;
delta_fq = 15;
fq_values = min_fq:delta_fq:max_fq;
num_fq = 20;

parfor x = 1:num_sp
  for y = 1:num_fq

    simulationNumber=x*num_fq+y;
    tic

    freq = fq_values(y);
    slot_thickness = sp_values(x);
    SLOT_PITCH = teeth_thickness+slot_thickness;
    Bs2 = slot_thickness;
    WIDTH_CORE=SLOT_PITCH*(SLOTS-1)+slot_thickness;

    pole_pitch = SLOTS*SLOT_PITCH;
    sync_speed(x,y) = 2*pole_pitch*freq;
    goodness(x,y) = pole_pitch^2*freq/GAP;

    Volume = (THICK_CORE*(WIDTH_CORE+2*END_EXT)*LENGTH) - (Bs2*Hs2*LENGTH*(SLOTS))*2; %Volume of DLIM in cm3
    Weight = Volume*coreMaterialDensity; %Weight of DLIM Core in g

    disp(append("starting Simulation Number ",num2str(simulationNumber)))

    inputHs2(x,y)=Hs2;
    inputDepth(x,y)=THICK_CORE;
    inputBs2(x,y)=Bs2;
    inputWidth(x,y)=WIDTH_CORE;
    inputNi(x,y)=inputCurrent*coilTurns; %Ni
    inputWeight(x,y)=Weight;
    inputVolume(x,y)=Volume;
    inputCoilArea(x,y)=coilArea;
    inputTeethThickness(x,y)=teeth_thickness;
    inputSlotThickness(x,y)=slot_thickness;
    inputCoreEndlength(x,y)=core_endlength;

    [losses,totalLosses,lforcex,lforcey,wstforcex,wstforcey,vA,vB,vC,cA,cB,cC,flA,flB,flC] = DLIM_GRWv2_Simulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH_CORE,THICK_CORE,LENGTH,GAP,SLOT_PITCH,SLOTS,Hs0,Hs01,Hs1,Hs2,Bs0,Bs1,Bs2,Rs,Layers,COIL_PITCH,core_endlength,coil_thickness,simulationNumber);
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

    singleSimTimeElapsed=toc;
    disp(append("Simulation Number ",num2str(simulationNumber)," completed in ",num2str(singleSimTimeElapsed)," seconds with parameters Hs2=",num2str(Hs2),", Bs2=",num2str(Bs2)))
    simulationNumber=simulationNumber+1;
    totalTimeElapsed = totalTimeElapsed+singleSimTimeElapsed;
  end
end

disp(append("Total Simulation Time: ",num2str(totalTimeElapsed),"seconds"))
save('freq_slotpitch_GRW.mat');
