%Define distributed processing Parameters
%numComputers = 3;
%cidFile = fopen("../../dist_proc/cid.txt");
%cp = fscanf(cidFile,'%d');
%c_id = cp(1);
%c_cores = cp(2);

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

totalTimeElapsed=0;
totalwidth = WIDTH/2+COIL_WIDTH;
simulationMax = totalwidth*2;
AREA = 2*(THICK_CORE+TEETH_EXTENSIONS)*TEETH_THICKNESS+(WIDTH-2*TEETH_EXTENSIONS)*CORE_THICKNESS; %Volume of DLIM in cm3

totalAngle=360;
angleIncrement=15;
angleDivisions=totalAngle/angleIncrement+1;

save('stability_results.mat');

parfor simulationNumber = 1:simulationMax
  tic;
  for angleIndex = 1:angleDivisions
<<<<<<< HEAD:TFLIM/Stability/mainR.m
    trackoffset = -simulationNumber;
=======
    trackoffset = simulationNumber;
>>>>>>> e0b824b526d6e3f3c9cb0c7a8dd124547ae6e1b5:TFLIM/Stability/mainL.m
    angle=(angleIndex-1)*angleIncrement;
    [losses,totalLosses,lforcex,lforcey,wstforcex,wstforcey,vL,vR,cL,cR,flL,flR] = TFLIMSimulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH,THICK_CORE,LENGTH,TEETH_THICKNESS,CORE_THICKNESS,COIL_WIDTH,TEETH_EXTENSIONS,AIR_GAP,TRACK_OFFSET,angle,simulationNumber);
    outputWSTForcex(simulationNumber,angleIndex)=wstforcex; %Weighted Stress Tensor Force on Track, x direction
    outputWSTForcey(simulationNumber,angleIndex)=wstforcey; %Weighted Stress Tensor Force on Track, y direction
    outputLForcex(simulationNumber,angleIndex)=lforcex; %Lorentz Force on Track, x direction
    outputLForcey(simulationNumber,angleIndex)=lforcey; %Lorentz Force on Track, y direction
    outputHLosses(simulationNumber,angleIndex)=losses; %Hysteresis Losses
    outputTLosses(simulationNumber,angleIndex)=totalLosses; %Total Losses
    outputVoltageL(simulationNumber,angleIndex)=vL; %Voltage of Winding L
    outputVoltageR(simulationNumber,angleIndex)=vR; %Voltage of Winding R
    outputCurrentA(simulationNumber,angleIndex)=cL; %Current of Winding L
    outputCurrentB(simulationNumber,angleIndex)=cR; %Current of Winding R
    outputResistanceA(simulationNumber,angleIndex)=vL/cL; %Resistance of Winding L
    outputResistanceB(simulationNumber,angleIndex)=vR/cR; %Resistance of Winding R
    outputFluxLinkageA(simulationNumber,angleIndex)=flL; %Flux Linkage of Winding L
    outputFluxLinkageB(simulationNumber,angleIndex)=flR;  %Flux Linkage of Winding R

    singleSimTimeElapsed=toc;
    disp(append("Simulation with number ",num2str(simulationNumber)," at angle ",num2str(angle)," completed in ",num2str(singleSimTimeElapsed)," seconds"))
    totalTimeElapsed = totalTimeElapsed+singleSimTimeElapsed;
  end
end

disp(append("Total Simulation Time: ",num2str(totalTimeElapsed),"seconds"))
save('stability_results.mat');
