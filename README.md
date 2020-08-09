# Electromagnetics Finite Element Analysis

Developing propulsion and levitation mechanisms for Hyperloop, using electromagnetic simulations for double-sided linear induction motors and 3D transverse flux linear induction motors. Software used includes Simcenter Magnetics (MagNet) and FEMM (Finite Element Method Magnetics). 

## FEMM + Matlab Setup

Using FEMM with Matlab requires FEMM files to be included into Matlab's search path. Replace `c:\\femm42\\mfiles` with the installation path of femm and use
```
addpath('c:\\femm42\\mfiles');
savepath;
```
to add the FEMM mfiles path to Matlab's search path.
