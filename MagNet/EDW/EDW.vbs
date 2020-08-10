Dim r1
Dim r2
Dim ra
Dim thickness
​
const PI = 3.1415926535
r1 = 120 / 2
r2 = 200 / 2
const n = 32
ra = 45 * PI / 180
thickness = 50
​
' M-19 26 Ga
' Copper: 100% IACS
​
Call newDocument()
Call SetLocale("en-us")
Call getDocument().setDefaultLengthUnit("Millimeters")
Set view = getDocument().getView()
​
​
' ----------------- Draw 2D Geometry
​
Call view.newCircle(0, 0, 2.0*r2)
​
Call getDocument().getView().getSlice().moveInALine(-thickness)
Call view.selectAt(0, 1.5*r2, infoSetSelection, Array(infoSliceSurface))
REDIM ArrayOfValues(0)
ArrayOfValues(0)= "Outer Air"
Call getDocument().getView().makeComponentInALine(3.0*thickness, ArrayOfValues, "Name=AIR", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
Call getDocument().setMaxElementSize("Outer Air", 1)
Call getDocument().getView().getSlice().moveInALine(thickness)
​
Call view.newCircle(0, 0, r1)
Call view.newCircle(0, 0, r2)
​
Dim x_hat
Dim y_hat
​
For i = 1 To n
	x_hat = Sin(PI * 2.0 * (i + 0.5) / n)
	y_hat = Cos(PI * 2.0 * (i + 0.5) / n)

	Call view.newLine(x_hat*r1, y_hat*r1, x_hat*r2, y_hat*r2)
Next
​
' ----------------- Create Components
​
ReDim Magnets(n - 1)
Dim mid
Dim direction
​
For i = 1 To n
	x_hat = Sin(PI * 2.0 * i / n)
	y_hat = Cos(PI * 2.0 * i / n)
	mid = (r1 + r2) / 2.0
​
	Call view.selectAt(x_hat*mid, y_hat*mid, infoSetSelection, Array(infoSliceSurface))
​
	x_hat = Sin(PI * 2.0 * i / n - i * ra)
	y_hat = Cos(PI * 2.0 * i / n - i * ra)
​
	direction = "[" & x_hat & "," & y_hat & ",0]"

	REDIM ArrayOfValues(0)
	ArrayOfValues(0)= "Magnet#" & i
	Call view.makeComponentInALine(thickness, ArrayOfValues, "Name=N50;Type=Uniform;Direction=" & direction, True)
​
	Call getDocument().setMaxElementSize("Magnet#" & i, 1)
​
	Magnets(i - 1) = "Magnet#" & i
Next
​
Call getDocument().makeMotionComponent(Magnets)
Call getDocument().setMotionSourceType("Motion#1", infoVelocityDriven)
Call getDocument().setMotionRotaryCenter("Motion#1", Array(0, 0, 0))
Call getDocument().setMotionRotaryAxis("Motion#1", Array(0, 0, 1))
​
Call getDocument().setMotionPositionAtStartup("Motion#1", 0)
Call getDocument().setMotionSpeedAtStartup("Motion#1", 0)
REDIM ArrayOfValues1(0)
ArrayOfValues1(0)= 0
REDIM ArrayOfValues2(0)
ArrayOfValues2(0)= 20000
Call getDocument().setMotionSpeedVsTime("Motion#1", ArrayOfValues1, ArrayOfValues2)
​
Call getDocument().setTimeStepMethod(infoAdaptiveTimeStep)
Call getDocument().setAdaptiveTimeSteps(0, 19, 1, 10)
