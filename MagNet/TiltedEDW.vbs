Dim wheelAngle
Dim magnetAngle
Dim magnetWidth
Dim magnetDepth
Dim innerRadius
Dim levitationHeight
Dim railClearance
Dim numMagnets
Dim rollAngle
Dim rpm

const PI = 3.1415926535

const beamHeight = 127
const beamWidth = 127
const webThickness = 10.4902
const flangeThickness = 10.4648
const plateThickness = 12.7
const plateGap = 12.7
const bottomForbiddenHeight = 29.6672
const topForbiddenHeight = 19.05
const topForbiddenWidth = 46.0502

const SHOW_FORBIDDEN_AIR = false

numMagnets = 16
rollAngle = 45.0 * PI / 180.0
innerRadius = 100 / 2.0
magnetWidth = 31.75
magnetDepth = 44.45
levitationHeight = 8
railClearance = 3
wheelAngle = 20.0 * PI / 180.0
magnetAngle = 40.0 * PI / 180.0
rpm = 360

Dim airX
Dim airYmin
Dim airYmax
Dim airZ

airX = innerRadius * 3.5
airYmin = -30.0
airYmax = beamHeight + 20
airZ = (innerRadius + magnetDepth) * 1

Dim airResolution
Dim aluminiumResolution
Dim magnetResolution

airResolution = 2
aluminiumResolution = 2
magnetResolution = 2

' M-19 26 Ga
' Copper: 100% IACS
' Aluminum: 3.8e7 Siemens/meter

Call newDocument()
Call SetLocale("en-us")
Call getDocument().setDefaultLengthUnit("Millimeters")
Set view = getDocument().getView()


' Air
Call view.newLine(-airX, airYmin, -airX, airYmax)
Call view.newLine(-airX, airYmax, airX, airYmax)
Call view.newLine(airX, airYmax, airX, airYmin)
Call view.newLine(airX, airYmin, -airX, airYmin)

Call view.getSlice().moveInALine(-airZ)
Call view.selectAt(0, 0, infoSetSelection, Array(infoSliceSurface))
Call view.makeComponentInALine(2.0*airZ, Array("Outer Air"), "Name=AIR", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
Call getDocument().setMaxElementSize("Outer Air", airResolution)
Call view.getSlice().moveInALine(airZ)

Call view.selectAll(infoSetSelection, Array(infoSliceLine))
Call view.deleteSelection()

' Magnets

Dim Ax
Dim Ay
Dim Bx
Dim By
Dim Cx
Dim Cy
Dim Dx
Dim Dy
Dim Px
Dim Py
Dim axisX
Dim axisY
Dim magnetMidX
Dim magnetMidY

Bx = -railClearance - flangeThickness/2.0
Ay = levitationHeight + 2.0*innerRadius*Sin(wheelAngle) + plateThickness
Ax = Bx - magnetWidth*Cos(wheelAngle + magnetAngle)
By = Ay + magnetWidth*Sin(wheelAngle + magnetAngle)
Cx = Bx - magnetDepth*Sin(wheelAngle + magnetAngle)
Cy = By + magnetDepth*Cos(wheelAngle + magnetAngle)
Dx = Ax - magnetDepth*Sin(wheelAngle + magnetAngle)
Dy = Ay + magnetDepth*Cos(wheelAngle + magnetAngle)

magnetMidX = (Ax + Bx + Cx + Dx) / 4.0
magnetMidY = (Ay + By + Cy + Dy) / 4.0

Px = -magnetWidth*Cos(wheelAngle + magnetAngle) - innerRadius*Cos(wheelAngle) - railClearance - flangeThickness/2.0
Py = innerRadius*Sin(wheelAngle) + levitationHeight + plateThickness
axisX = -Sin(wheelAngle)
axisY = Cos(wheelAngle)

Call view.newLine(Ax, Ay, Bx, By)
Call view.newLine(Bx, By, Cx, Cy)
Call view.newLine(Cx, Cy, Dx, Dy)
Call view.newLine(Dx, Dy, Ax, Ay)

'Call view.newLine(Px, Py, Px + axisX*100, Py + axisY*100)

ReDim MagnetsA(numMagnets - 1)

For i = 1 To numMagnets
	circleAngle = PI * 2.0 * (i - 0.5) / numMagnets

	' Circumferential vector
	x1 = -Cos(wheelAngle)*Sin(circleAngle)
	y1 = -Sin(wheelAngle)*Sin(circleAngle)
	z1 = -Cos(circleAngle)

	' Vector normal to outwards face  --- NOT PERFECT
	y2 = -Cos(magnetAngle + wheelAngle*Cos(circleAngle)) '-Cos(magnetAngle) + Sin(wheelAngle)*Cos(circleAngle)
	z2 = -Sin(magnetAngle)*Sin(circleAngle)
	x2 = Sin(magnetAngle)*Cos(circleAngle) + Sin(wheelAngle) 'Sin(magnetAngle + wheelAngle*Cos(circleAngle)) 'Sin(magnetAngle)*Cos(circleAngle) + Sin(wheelAngle)*Cos(circleAngle)

	magnetizationAngle = -i * rollAngle

	x_hat = x1*Sin(magnetizationAngle) + x2*Cos(magnetizationAngle)
	y_hat = y1*Sin(magnetizationAngle) + y2*Cos(magnetizationAngle)
	z_hat = z1*Sin(magnetizationAngle) + z2*Cos(magnetizationAngle)

	direction = "[" & x_hat & "," & y_hat & "," & z_hat & "]"
	' direction = "[1,0,0]"

	Call view.selectAll(infoSetSelection, Array(infoSliceSurface))

	ReDim ArrayOfValues(0)
	ArrayOfValues(0)= "Magnet#" & i
	Call view.makeComponentInAnArc(Px, Py, axisX, axisY, 360.0 / numMagnets, ArrayOfValues, "Name=N50;Type=Uniform;Direction=" & direction, infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)

	Call getDocument().setMaxElementSize("Magnet#" & i, magnetResolution)

	Call view.getSlice().moveInAnArc(Px, Py, axisX, axisY, 360.0 / numMagnets)

	MagnetsA(i - 1) = "Magnet#" & i
Next

Call view.getSlice().moveInAnArc(0, 0, 0, 1, 180.0)

ReDim MagnetsB(numMagnets - 1)

For i = 1 To numMagnets
	circleAngle = PI * 2.0 * (i - 0.5) / numMagnets

	' Circumferential vector
	x1 = Cos(wheelAngle)*Sin(circleAngle)
	y1 = -Sin(wheelAngle)*Sin(circleAngle)
	z1 = -Cos(circleAngle)

	' Vector pointing outwards on magnet
	y2 = -Cos(magnetAngle + wheelAngle*Cos(circleAngle)) '-Cos(magnetAngle) + Sin(wheelAngle)*Cos(circleAngle)
	z2 = -Sin(magnetAngle)*Sin(circleAngle)
	x2 = -Sin(magnetAngle)*Cos(circleAngle) - Sin(wheelAngle) 'Sin(magnetAngle + wheelAngle*Cos(circleAngle)) 'Sin(magnetAngle)*Cos(circleAngle) + Sin(wheelAngle)*Cos(circleAngle)

	magnetizationAngle = -i * rollAngle + PI

	x_hat = x1*Sin(magnetizationAngle) + x2*Cos(magnetizationAngle)
	y_hat = y1*Sin(magnetizationAngle) + y2*Cos(magnetizationAngle)
	z_hat = z1*Sin(magnetizationAngle) + z2*Cos(magnetizationAngle)

	direction = "[" & x_hat & "," & y_hat & "," & z_hat & "]"

	Call view.selectAll(infoSetSelection, Array(infoSliceSurface))

	ReDim ArrayOfValues(0)
	ArrayOfValues(0)= "MagnetB#" & i
	Call view.makeComponentInAnArc(Px, Py, axisX, axisY, -360.0 / numMagnets, ArrayOfValues, "Name=N50;Type=Uniform;Direction=" & direction, infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)

	Call getDocument().setMaxElementSize("MagnetB#" & i, magnetResolution)

	Call view.getSlice().moveInAnArc(Px, Py, axisX, axisY, -360.0 / numMagnets)

	MagnetsB(i - 1) = "MagnetB#" & i
Next

Call view.getSlice().moveInAnArc(0, 0, 0, 1, 180.0)
Call view.selectAll(infoSetSelection, Array(infoSliceLine))
Call view.deleteSelection()

' Magnet Motion

Call getDocument().makeMotionComponent(MagnetsA)
Call getDocument().setMotionSourceType("Motion#1", infoVelocityDriven)
Call getDocument().setMotionRotaryCenter("Motion#1", Array(Px, Py, 0))
Call getDocument().setMotionRotaryAxis("Motion#1", Array(axisX, axisY, 0))
Call getDocument().setMotionPositionAtStartup("Motion#1", 0)
Call getDocument().setMotionSpeedAtStartup("Motion#1", 0)
Call getDocument().setMotionSpeedVsTime("Motion#1", Array(0), Array(rpm*6.0))

Call getDocument().makeMotionComponent(MagnetsB)
Call getDocument().setMotionSourceType("Motion#2", infoVelocityDriven)
Call getDocument().setMotionRotaryCenter("Motion#2", Array(-Px, Py, 0))
Call getDocument().setMotionRotaryAxis("Motion#2", Array(-axisX, axisY, 0))
Call getDocument().setMotionPositionAtStartup("Motion#2", 0)
Call getDocument().setMotionSpeedAtStartup("Motion#2", 0)
Call getDocument().setMotionSpeedVsTime("Motion#2", Array(0), Array(-rpm*6.0))

' Forbidden Zones

If SHOW_FORBIDDEN_AIR Then
	Call view.newLine(-beamWidth/2.0 - plateGap, 0, -beamWidth/2.0 - plateGap, bottomForbiddenHeight)
	Call view.newLine(-beamWidth/2.0 - plateGap, bottomForbiddenHeight, beamWidth/2.0 + plateGap, bottomForbiddenHeight)
	Call view.newLine(beamWidth/2.0 + plateGap, bottomForbiddenHeight, beamWidth/2.0 + plateGap, 0)
	Call view.newLine(beamWidth/2.0 + plateGap, 0, -beamWidth/2.0 - plateGap, 0)

	Call view.newLine(-topForbiddenWidth/2.0, beamHeight - flangeThickness - topForbiddenHeight, -topForbiddenWidth/2.0, beamHeight - flangeThickness)
	Call view.newLine(-topForbiddenWidth/2.0, beamHeight - flangeThickness, topForbiddenWidth/2.0, beamHeight - flangeThickness)
	Call view.newLine(topForbiddenWidth/2.0, beamHeight - flangeThickness, topForbiddenWidth/2.0, beamHeight - flangeThickness - topForbiddenHeight)
	Call view.newLine(topForbiddenWidth/2.0, beamHeight - flangeThickness - topForbiddenHeight, -topForbiddenWidth/2.0, beamHeight - flangeThickness - topForbiddenHeight)

	Call view.getSlice().moveInALine(-airZ)

	Call view.selectAt(0, bottomForbiddenHeight/2.0, infoSetSelection, Array(infoSliceSurface))
	Call view.makeComponentInALine(2.0*airZ, Array("Forbidden Air 1"), "Name=AIR", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
	Call getDocument().setMaxElementSize("Forbidden Air 1", airResolution)
	Call getDocument().setComponentColor("Forbidden Air 1", RGB(255, 0, 0), 50)

	Call view.selectAt(0, beamHeight - flangeThickness - topForbiddenHeight/2.0, infoSetSelection, Array(infoSliceSurface))
	Call view.makeComponentInALine(2.0*airZ, Array("Forbidden Air 2"), "Name=AIR", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
	Call getDocument().setMaxElementSize("Forbidden Air 2", airResolution)
	Call getDocument().setComponentColor("Forbidden Air 2", RGB(255, 0, 0), 50)

	Call view.getSlice().moveInALine(airZ)
	Call view.selectAll(infoSetSelection, Array(infoSliceLine))
	Call view.deleteSelection()
End If

' Rail

Call view.newLine(-beamWidth/2.0, 0, beamWidth/2.0, 0)
Call view.newLine(beamWidth/2.0, 0, beamWidth/2.0, flangeThickness)
Call view.newLine(beamWidth/2.0, flangeThickness, webThickness/2.0, flangeThickness)
Call view.newLine(webThickness/2.0, flangeThickness, webThickness/2.0, beamHeight - flangeThickness)
Call view.newLine(webThickness/2.0, beamHeight - flangeThickness, beamWidth/2.0, beamHeight - flangeThickness)
Call view.newLine(beamWidth/2.0, beamHeight - flangeThickness, beamWidth/2.0, beamHeight)
Call view.newLine(beamWidth/2.0, beamHeight, -beamWidth/2.0, beamHeight)
Call view.newLine(-beamWidth/2.0, beamHeight, -beamWidth/2.0, beamHeight - flangeThickness)
Call view.newLine(-beamWidth/2.0, beamHeight - flangeThickness, -webThickness/2.0, beamHeight - flangeThickness)
Call view.newLine(-webThickness/2.0, beamHeight - flangeThickness, -webThickness/2.0, flangeThickness)
Call view.newLine(-webThickness/2.0, flangeThickness, -beamWidth/2.0, flangeThickness)
Call view.newLine(-beamWidth/2.0, flangeThickness, -beamWidth/2.0, 0)

Call view.newLine(-airX, 0, -beamWidth/2.0 - plateGap, 0)
Call view.newLine(-beamWidth/2.0 - plateGap, 0, -beamWidth/2.0 - plateGap, plateThickness)
Call view.newLine(-beamWidth/2.0 - plateGap, plateThickness, -airX, plateThickness)
Call view.newLine(-airX, plateThickness, -airX, 0)

Call view.newLine(airX, 0, beamWidth/2.0 + plateGap, 0)
Call view.newLine(beamWidth/2.0 + plateGap, 0, beamWidth/2.0 + plateGap, plateThickness)
Call view.newLine(beamWidth/2.0 + plateGap, plateThickness, airX, plateThickness)
Call view.newLine(airX, plateThickness, airX, 0)

Call view.getSlice().moveInALine(-airZ)

Call view.selectAt(0, beamHeight/2.0, infoSetSelection, Array(infoSliceSurface))
Call view.makeComponentInALine(2.0*airZ, Array("Rail"), "Name=Aluminum: 3.8e7 Siemens/meter", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
Call getDocument().setMaxElementSize("Rail", aluminiumResolution)

Call view.selectAt(-beamWidth-plateGap-10, plateThickness/2.0, infoSetSelection, Array(infoSliceSurface))
Call view.makeComponentInALine(2.0*airZ, Array("Plate1"), "Name=Aluminum: 3.8e7 Siemens/meter", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
Call getDocument().setMaxElementSize("Plate1", aluminiumResolution)

Call view.selectAt(beamWidth+plateGap+10, plateThickness/2.0, infoSetSelection, Array(infoSliceSurface))
Call view.makeComponentInALine(2.0*airZ, Array("Plate2"), "Name=Aluminum: 3.8e7 Siemens/meter", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
Call getDocument().setMaxElementSize("Plate2", aluminiumResolution)

Call view.getSlice().moveInALine(airZ)
Call view.selectAll(infoSetSelection, Array(infoSliceLine))
Call view.deleteSelection()

' Setup Simulation

Call getDocument().setTimeStepMethod(infoAdaptiveTimeStep)
Call getDocument().setAdaptiveTimeSteps(0, 5, 1, 10)

' Scale view to fit

Call getDocument().getView().setScaledToFit(True)
