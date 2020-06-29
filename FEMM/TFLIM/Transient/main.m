%Simulation Description:
%Transient Simulations

%Set up environment (clear previous)
clc;
clear;

%Define TFLIM Parameters
inputCurrent = 10;
freq = 15;
coilTurns = 310;
trackThickness = 8;
copperMaterial = '20 AWG';
trackMaterial = 'Aluminum, 6061-T6';
coreMaterial = 'M-19 Steel';

THICK_CORE=60;
WIDTH = 100;
LENGTH = 50; %Core length
TEETH_THICKNESS = 25;
CORE_THICKNESS = 20;
COIL_WIDTH=15;
TEETH_EXTENSIONS=10;
AIR_GAP=5;
TRACK_OFFSET=0;

%Define Simulation Specific Parameters
AREA = 2*(THICK_CORE+TEETH_EXTENSIONS)*TEETH_THICKNESS+(WIDTH-2*TEETH_EXTENSIONS)*CORE_THICKNESS; %Volume of DLIM in cm3

%Simulation counter/duration Variables
totalTimeElapsed = 0;

parfor angle=1:360
  singleSimTimeElapsed = 0;
  tic

  [losses,totalLosses,lforcex,lforcey,wstforcex,wstforcey,vL,vR,cL,cR,flL,flR] = TFLIMSimulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH,THICK_CORE,LENGTH,TEETH_THICKNESS,CORE_THICKNESS,COIL_WIDTH,TEETH_EXTENSIONS,AIR_GAP,TRACK_OFFSET,angle);
  outputWSTForcex(angle)=wstforcex; %Weighted Stress Tensor Force on Track, x direction
  outputWSTForcey(angle)=wstforcey; %Weighted Stress Tensor Force on Track, y direction
  outputLForcex(angle)=lforcex; %Lorentz Force on Track, x direction
  outputLForcey(angle)=lforcey; %Lorentz Force on Track, y direction
  outputHLosses(angle)=losses; %Hysteresis Losses
  outputTLosses(angle)=totalLosses; %Total Losses
  outputVoltageL(angle)=vL; %Voltage of Winding L
  outputVoltageR(angle)=vR; %Voltage of Winding R
  outputCurrentA(angle)=cL; %Current of Winding L
  outputCurrentB(angle)=cR; %Current of Winding R
  outputResistanceA(angle)=vL/cL; %Resistance of Winding L
  outputResistanceB(angle)=vR/cR; %Resistance of Winding R
  outputFluxLinkageA(angle)=flL; %Flux Linkage of Winding L
  outputFluxLinkageB(angle)=flR;  %Flux Linkage of Winding R

  %save('transient_results.mat');
  singleSimTimeElapsed=toc;
  disp(append("Simulation at angle ",num2str(angle)," completed in ",num2str(singleSimTimeElapsed)," seconds"))
  totalTimeElapsed = totalTimeElapsed+singleSimTimeElapsed;
end

disp(append("Total Simulation Time: ",num2str(totalTimeElapsed),"seconds"))
save('transient_results.mat');
