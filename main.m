%Define LIM Parameters (Parallel to ANSYS rmXprt LinearMCore definition)
WIDTH_CORE = 370; %Core width in motion direction
THICK_CORE = 60; %Core thickness
LENGTH = 50; %Core length
GAP = 15; %Gap between core and xy plane (or 1/2 of air gap)
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
coilTurns = 360;
trackThickness = 8;
copperMaterial = '20 AWG';
trackMaterial = 'Aluminum, 6061-T6';
coreMaterial = 'M-19 Steel';

%Define Simulation Specific Parameters
sumSlotTeeth = SLOTS*2+1; %Number of Teeth + Slots
slotGap = SLOT_PITCH-Bs1; %Width of an Individual Slot
slotTeethWidth = (SLOTS-1)*SLOT_PITCH+slotGap;
coilArea = slotGap*Hs2/2; %Area of coil for a single phase

[losses,totalLosses,lforcex,lforcey,wstforcex,wstforcey,vA,vB,vC,cA,cB,cC,flA,flB,flC] = DLIMSimulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH_CORE,THICK_CORE,LENGTH,GAP,SLOT_PITCH,SLOTS,Hs0,Hs01,Hs1,Hs2,Bs0,Bs1,Bs2,Rs,Layers,COIL_PITCH,END_EXT);
