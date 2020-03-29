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


totalwidth = WIDTH/2+COIL_WIDTH;
AREA = 2*(THICK_CORE+TEETH_EXTENSIONS)*TEETH_THICKNESS+(WIDTH-2*TEETH_EXTENSIONS)*CORE_THICKNESS; %Volume of DLIM in cm3

save('stability_results.mat');

parfor simulationNumber = 1:2*totalwidth
  tic;
  for x=0:15:360

    [losses,totalLosses,lforcex,lforcey,wstforcex,wstforcey,vL,vR,cL,cR,flL,flR] = TFLIMSimulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH,THICK_CORE,LENGTH,TEETH_THICKNESS,CORE_THICKNESS,COIL_WIDTH,TEETH_EXTENSIONS,AIR_GAP,TRACK_OFFSET,angle,simulationNumber);
    outputWSTForcex(simulationNumber)=wstforcex; %Weighted Stress Tensor Force on Track, x direction
    outputWSTForcey(simulationNumber)=wstforcey; %Weighted Stress Tensor Force on Track, y direction
    outputLForcex(simulationNumber)=lforcex; %Lorentz Force on Track, x direction
    outputLForcey(simulationNumber)=lforcey; %Lorentz Force on Track, y direction
    outputHLosses(simulationNumber)=losses; %Hysteresis Losses
    outputTLosses(simulationNumber)=totalLosses; %Total Losses
    outputVoltageL(simulationNumber)=vL; %Voltage of Winding L
    outputVoltageR(simulationNumber)=vR; %Voltage of Winding R
    outputCurrentA(simulationNumber)=cL; %Current of Winding L
    outputCurrentB(simulationNumber)=cR; %Current of Winding R
    outputResistanceA(simulationNumber)=vL/cL; %Resistance of Winding L
    outputResistanceB(simulationNumber)=vR/cR; %Resistance of Winding R
    outputFluxLinkageA(simulationNumber)=flL; %Flux Linkage of Winding L
    outputFluxLinkageB(simulationNumber)=flR;  %Flux Linkage of Winding R

    singleSimTimeElapsed=toc;
    disp(append("Simulation at angle ",num2str(angle)," completed in ",num2str(singleSimTimeElapsed)," seconds"))
    totalTimeElapsed = totalTimeElapsed+singleSimTimeElapsed;
  end
end
save('stability_results.mat');
