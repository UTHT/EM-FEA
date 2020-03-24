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

ANGLE=0;
AREA = 2*(THICK_CORE+TEETH_EXTENSIONS)*TEETH_THICKNESS+(WIDTH-2*TEETH_EXTENSIONS)*CORE_THICKNESS; %Volume of DLIM in cm3


[losses,totalLosses,lforcex,lforcey,wstforcex,wstforcey,vL,vR,cL,cR,flL,flR] = TFLIMSimulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH,THICK_CORE,LENGTH,TEETH_THICKNESS,CORE_THICKNESS,COIL_WIDTH,TEETH_EXTENSIONS,AIR_GAP,TRACK_OFFSET,ANGLE);
