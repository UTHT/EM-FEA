# FEMMSimulations

Fast magnetostatic simulations for double-sided linear induction motors in FEMM/Matlab. 

## Simulation Parameters

Utilized | Parameter Name | Default Value | Description | 
------- | -------- | ------- | --------
WIDTH_CORE = 460; %Core width in motion direction
THICK_CORE = 50; %Core thickness
LENGTH = 50; %Core length
GAP = 17.5; %Gap between core and xy plane (or 1/2 of air gap)
SLOT_PITCH = 40; %Distance between two slots
SLOTS = 11; %Number of slots
Hs0 = 0; %Slot opening height
Hs01 = 0; %Slot closed bridge height
Hs1 = 0; %Slot wedge height
Hs2 = 20; %Slot body height
Bs0 = 20; %Slot opening width
Bs1 = 20; %Slot wedge maximum Width
Bs2 = 20; %Slot body bottom width
Rs = 0; %Slot body bottom fillet
Layers = 2; %Number of winding layers
COIL_PITCH = 2; %Coil Pitch measured in slots
END_EXT = 0; %One-sided winding end extended length
SPAN_EXT = 20; %Axial length of winding end span
SEG_ANGLE = 15; %Deviation angle for slot arches

## Matlab Setup

Using FEMM with Matlab requires FEMM files to be included into Matlab's search path. Replace `c:\\femm42\\mfiles` with the installation path of femm and use
```
addpath('c:\\femm42\\mfiles');
savepath;
```
to add the FEMM mfiles path to Matlab's search path. 
