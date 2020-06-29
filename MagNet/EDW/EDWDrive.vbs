Dim r1
Dim r2
Dim ra
Dim gap
Dim thickness
Dim rail_thickness
Dim rpm

const PI = 3.1415926535
const n = 32
r1 = 120 / 2
r2 = 200 / 2
ra = 45 * PI / 180
gap = 20.5
thickness = 50
rail_thickness = 10.5
rpm = 360

' M-19 26 Ga
' Copper: 100% IACS
' Aluminum: 3.8e7 Siemens/meter

Call newDocument()
Call SetLocale("en-us")
Call getDocument().setDefaultLengthUnit("Millimeters")
Set view = getDocument().getView()


' Air

Call view.newLine(-r2*3.0, -r2*3.0, r2*3.0, -r2*3.0)
Call view.newLine(r2*3.0, -r2*3.0, r2*3.0, r2*3.0)
Call view.newLine(r2*3.0, r2*3.0, -r2*3.0, r2*3.0)
Call view.newLine(-r2*3.0, r2*3.0, -r2*3.0, -r2*3.0)

Call getDocument().getView().getSlice().moveInALine(-thickness)
Call view.selectAt(0, 0, infoSetSelection, Array(infoSliceSurface))
REDIM ArrayOfValues(0)
ArrayOfValues(0)= "Outer Air"
Call getDocument().getView().makeComponentInALine(3.0*thickness, ArrayOfValues, "Name=AIR", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
Call getDocument().setMaxElementSize("Outer Air", 1)
Call getDocument().getView().getSlice().moveInALine(thickness)

' Aluminium

Call view.newLine(hickness/2.0, -r2*3.0,rail_thickness/2.0, -r2*3.0)
Call view.newLine(rail_thickness/2.0, -r2*3.0, rail_thickness/2.0, r2*3.0)
Call view.newLine(rail_thickness/2.0, r2*3.0, -rail_thickness/2.0, r2*3.0)
Call view.newLine(-rail_thickness/2.0, r2*3.0, -rail_thickness/2.0, -r2*3.0)

Call getDocument().getView().getSlice().moveInALine(-thickness)
Call view.selectAt(0, 0, infoSetSelection, Array(infoSliceSurface))
REDIM ArrayOfValues(0)
ArrayOfValues(0)= "Aluminium"
Call getDocument().getView().makeComponentInALine(3.0*thickness, ArrayOfValues, "Name=Aluminum: 3.8e7 Siemens/meter", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
Call getDocument().setMaxElementSize("Aluminium", 1)
Call getDocument().getView().getSlice().moveInALine(thickness)


' Magnets 1

Call view.newCircle((r2 + gap/2.0), 0, r1)
Call view.newCircle((r2 + gap/2.0), 0, r2)

Dim x_hat
Dim y_hat

For i = 1 To n
	x_hat = Sin(PI * 2.0 * (i + 0.5) / n)
	y_hat = Cos(PI * 2.0 * (i + 0.5) / n)

	Call view.newLine((r2 + gap/2.0) + x_hat*r1, y_hat*r1, (r2 + gap/2.0) + x_hat*r2, y_hat*r2)
Next

ReDim Magnets(n - 1)
Dim mid
Dim direction

For i = 1 To n
	x_hat = Sin(PI * 2.0 * i / n)
	y_hat = Cos(PI * 2.0 * i / n)
	mid = (r1 + r2) / 2.0

	Call view.selectAt((r2 + gap/2.0) + x_hat*mid, y_hat*mid, infoSetSelection, Array(infoSliceSurface))

	x_hat = Sin(PI * 2.0 * i / n - i * ra)
	y_hat = Cos(PI * 2.0 * i / n - i * ra)

	direction = "[" & x_hat & "," & y_hat & ",0]"

	REDIM ArrayOfValues(0)
	ArrayOfValues(0)= "Magnet#" & i
	Call view.makeComponentInALine(thickness, ArrayOfValues, "Name=N50;Type=Uniform;Direction=" & direction, True)

	Call getDocument().setMaxElementSize("Magnet#" & i, 1)

	Magnets(i - 1) = "Magnet#" & i
Next

' Motion

Call getDocument().makeMotionComponent(Magnets)
Call getDocument().setMotionSourceType("Motion#1", infoVelocityDriven)
Call getDocument().setMotionRotaryCenter("Motion#1", Array((r2 + gap/2.0), 0, 0))
Call getDocument().setMotionRotaryAxis("Motion#1", Array(0, 0, 1))

Call getDocument().setMotionPositionAtStartup("Motion#1", 0)
Call getDocument().setMotionSpeedAtStartup("Motion#1", 0)
REDIM ArrayOfValues1(0)
ArrayOfValues1(0)= 0
REDIM ArrayOfValues2(0)
ArrayOfValues2(0)= rpm*6.0
Call getDocument().setMotionSpeedVsTime("Motion#1", ArrayOfValues1, ArrayOfValues2)

' Magnets 2

Call view.newCircle(-(r2 + gap/2.0), 0, r1)
Call view.newCircle(-(r2 + gap/2.0), 0, r2)
For i = 1 To n
	x_hat = Sin(PI * 2.0 * (i + 0.5) / n)
	y_hat = Cos(PI * 2.0 * (i + 0.5) / n)

	Call view.newLine(-(r2 + gap/2.0) + x_hat*r1, y_hat*r1, -(r2 + gap/2.0) + x_hat*r2, y_hat*r2)
Next

ReDim Magnets(n - 1)

For i = 1 To n
	x_hat = Sin(PI * 2.0 * i / n)
	y_hat = Cos(PI * 2.0 * i / n)
	mid = (r1 + r2) / 2.0

	Call view.selectAt(-(r2 + gap/2.0) + x_hat*mid, y_hat*mid, infoSetSelection, Array(infoSliceSurface))

	x_hat = Sin(PI * 2.0 * i / n - i * ra - PI)
	y_hat = Cos(PI * 2.0 * i / n - i * ra - PI)

	direction = "[" & x_hat & "," & y_hat & ",0]"

	REDIM ArrayOfValues(0)
	ArrayOfValues(0)= "Magnet2#" & i
	Call view.makeComponentInALine(thickness, ArrayOfValues, "Name=N50;Type=Uniform;Direction=" & direction, True)

	Call getDocument().setMaxElementSize("Magnet2#" & i, 1)

	Magnets(i - 1) = "Magnet2#" & i
Next

' Motion

Call getDocument().makeMotionComponent(Magnets)
Call getDocument().setMotionSourceType("Motion#2", infoVelocityDriven)
Call getDocument().setMotionRotaryCenter("Motion#2", Array(-(r2 + gap/2.0), 0, 0))
Call getDocument().setMotionRotaryAxis("Motion#2", Array(0, 0, 1))

Call getDocument().setMotionPositionAtStartup("Motion#2", 0)
Call getDocument().setMotionSpeedAtStartup("Motion#2", 0)
REDIM ArrayOfValues1(0)
ArrayOfValues1(0)= 0
REDIM ArrayOfValues2(0)
ArrayOfValues2(0)= -rpm*6.0
Call getDocument().setMotionSpeedVsTime("Motion#2", ArrayOfValues1, ArrayOfValues2)


Call getDocument().setTimeStepMethod(infoAdaptiveTimeStep)
Call getDocument().setAdaptiveTimeSteps(0, 5, 1, 10)
