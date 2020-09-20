# Electromagnetics Finite Element Analysis

Developing propulsion and levitation mechanisms for Hyperloop, using electromagnetic simulations for double-sided linear induction motors and 3D transverse flux linear induction motors. Software used includes Simcenter Magnetics (MagNet) and FEMM (Finite Element Method Magnetics). 

## FEMM + Matlab Setup

Using FEMM with Matlab requires FEMM files to be included into Matlab's search path. Replace `c:\\femm42\\mfiles` with the installation path of femm and use
```
addpath('c:\\femm42\\mfiles');
savepath;
```
to add the FEMM mfiles path to Matlab's search path.

## Directory Structure

* FEMM (Matlab code for various projects)
  * DLIM
    * Double-sided LIM simulations
  * DLIMv2
    * DLIM version 2 - updated simulation code, no results
  * DLIM_GRW
    * DLIM Gramme-Ring Windings simulations
  * LHD
    * Linear Halbach Drive simulations
  * TFLIM
    * Transverse Flux LIM simulations (in 2D)
* MagNet (VBS code for various projects)
  * EDW
    * Electrodynamic Wheel simulations
  * LIM
    * Linear Induction Motor simulations
