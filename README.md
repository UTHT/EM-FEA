# FEMMSimulations

Fast magnetostatic simulations for double-sided linear induction motors in FEMM/Matlab.


## Matlab Setup

Using FEMM with Matlab requires FEMM files to be included into Matlab's search path. Replace `c:\\femm42\\mfiles` with the installation path of femm and use
```
addpath('c:\\femm42\\mfiles');
savepath;
```
to add the FEMM mfiles path to Matlab's search path.


## Simulation Parameters

List of parameters used by the Matlab code to simulate in the DLIM core design. Defined length units are defined in the initial problem setup using `mi_probdef`.

 -- | Parameter Name | Default Value | Description | Units
------- | -------- | ------- | -------- | --------
[x] |WIDTH_CORE | 460 |  Core width in motion direction | defined length unit
[x] |THICK_CORE | 50 |  Core thickness | defined length unit
[x] |LENGTH | 50 |  Core length | defined length unit
[x] |GAP | 17.5 |  Gap between core and xy plane (or 1/2 of air gap) | defined length unit
[x] |SLOT_PITCH | 40 |  Distance between two slots | defined length unit
[x] |SLOTS | 11 |  Number of slots |
[] |Hs0 | 0 |  Slot opening height | defined length unit
[] |Hs01 | 0 |  Slot closed bridge height | defined length unit
[] |Hs1 | 0 |  Slot wedge height | defined length unit
[x] |Hs2 | 20 |  Slot body height | defined length unit
[] |Bs0 | 20 |  Slot opening width | defined length unit
[] |Bs1 | 20 |  Slot wedge maximum Width | defined length unit
[x] |Bs2 | 20 |  Slot body bottom width | defined length unit
[] |Rs | 0 |  Slot body bottom fillet | defined length unit
[] |Layers | 2 |  Number of winding layers |
[] |COIL_PITCH | 2 |  Coil Pitch measured in slots |
[x] |END_EXT | 0 |  One-sided winding end extended length | defined length unit
[] |SPAN_EXT | 20 |  Axial length of winding end span | defined length unit
[] |SEG_ANGLE | 15 |  Deviation angle for slot arches | degrees
[x] | inputCurrent | 10 | Current in | A
[x] | freq | 60 | Simulation frequency | Hz
[x] | coilTurns | 360 | number of coil turns |
[x] | trackThickness | 8 | thickness of track | defined length unit
[x] | copperMaterial | '16 AWG' | copper wire material |
[x] | coreMaterial | 'M-19 Steel' | DLIM core material |
[x] | trackMaterial | 'Aluminum, 6061-T6' | track material |
