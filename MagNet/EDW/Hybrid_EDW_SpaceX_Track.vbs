const PI = 3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067

' Track dimensions
const railHeight = 127
const railWidth = 127
const webThickness = 10.4902
const flangeThickness = 10.4648
const plateThickness = 12.7
const plateGap = 12.7
const bottomForbiddenHeight = 29.6672
const topForbiddenHeight = 19.05
const topForbiddenWidth = 46.0502

const SHOW_FORBIDDEN_AIR = True		' Show forbidden zones for design purposes (as red air regions)
const SHOW_FULL_GEOMETRY = True		' Build with flanges of track
const BUILD_WITH_SYMMETRY = False	' Build only half of the track and one wheel, with symmetry conditions
const runSimulation = False			' Automatically run simulation

' EDW dimensions
numMagnets = 12						' Number of magnets per wheel
rollAngle = 90.0 * PI / 180.0		' Change in angle between consecutive magnets (rad)
innerRadius = 100 / 2.0				' Inner radius of wheel
magnetWidth = 25.4					' Width of magnets
magnetDepth = 38.1					' Depth of magnets
levitationHeight = 8				' Height from lowest point of magnets to conducting plate
railClearance = 6					' Clearance from magnets to rail
wheelAngle = 25.0 * PI / 180.0   	' Tilt of entire wheel assembly towards rail (from horizontal) (rad)
magnetAngle = 60.0 * PI / 180.0  	' Tilt of individual magnets outwards (from pointing downwards) (rad)
offsetX = 0.0						' Offset of both wheels laterally to test for guidance force (only works when simulating without symmetry)

If BUILD_WITH_SYMMETRY Then
    offsetX = 0.0
End If

' Speeds in m/s
speed = 25.0						' Speed of pod
slipSpeed = 30.0					' Slip speed if numSpeedSteps = 1
minSlipSpeed = 12.0					' Starting test slip speed
maxSlipSpeed = 22.0					' Ending test slip speed
numSpeedSteps = 5					' Number of tests, slip speed is linearly spaces from minSlipSpeed to maxSlipSpeed

solveStepsPerMagnet = 8.0	' Number of steps needed for wheel to rotate the angle of one magnet
numSteps = 8*18				' Number of simulation steps

' Use min rps to calculate solve
rps = (speed + minSlipSpeed) / magneticCircumference
solveStep = 1000.0 / (rps * numMagnets * solveStepsPerMagnet)

magneticCircumference = 1.04 * innerRadius*PI*2.0 / 1000.0		' Magnetic circumference of wheel (important for accurate slip speeds)

' Air boundaries
airX = innerRadius * 3.0
airYmin = -10.0
airYmax = railHeight + 1
airCutY = 70.0
airZ = (innerRadius + magnetWidth*Cos(magnetAngle)) * 1.6

motionLength = speed * (solveStep * numSteps)

airRailBoundary = 1
airResolution = 6
aluminiumResolution = 5
magnetResolution = 5
railSurfaceResolution = 2
plateSurfaceResolution = 3
magnetFaceResolution = 3
motionAirFaceResolution = magnetFaceResolution
useHAdaption = False
usePAdaption = False


' M-19 26 Ga
' Copper: 100% IACS
' Aluminum: 3.8e7 Siemens/meter

Call newDocument()
Call SetLocale("en-us")
Call getDocument().setDefaultLengthUnit("Millimeters")
Set view = getDocument().getView()

' Air

If BUILD_WITH_SYMMETRY Then
	Call view.newLine(-airX, airYmin, -airX, airCutY)
	Call view.newLine(-airX, airCutY, -railWidth/2.0, airYmax)
	Call view.newLine(-railWidth/2.0, airYmax, 0, airYMax)
	Call view.newLine(0, airYmax, 0, airYmin)
	Call view.newLine(0, airYmin, -airX, airYmin)
Else
	Call view.newLine(-airX, airYmin, -airX, airCutY)
	Call view.newLine(-airX, airCutY, -railWidth/2.0, airYmax)
	Call view.newLine(-railWidth/2.0, airYmax, railWidth/2.0, airYMax)
	Call view.newLine(airX, airYmin, airX, airCutY)
	Call view.newLine(airX, airCutY, railWidth/2.0, airYmax)
	Call view.newLine(-airX, airYmin, airX, airYmin)
End If

Call view.getSlice().moveInALine(-airZ - motionLength - airRailBoundary)
Call view.selectAt(-1, 1, infoSetSelection, Array(infoSliceSurface))
Call view.makeComponentInALine(airZ*2 + motionLength*2 + airRailBoundary*2, Array("Outer Air"), "Name=AIR", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
Call getDocument().setMaxElementSize("Outer Air", airResolution)
Call view.getSlice().moveInALine(airZ + motionLength + airRailBoundary)
Call getDocument().getView().setObjectVisible("Outer Air", False)

Call view.selectAll(infoSetSelection, Array(infoSliceLine))
Call view.deleteSelection()

If BUILD_WITH_SYMMETRY Then
	Call getDocument().createBoundaryCondition(Array("Outer Air,Face#4"), "BoundaryCondition#1")
	Call getDocument().setMagneticFieldNormal("BoundaryCondition#1")
End If

' Forbidden Zones

If SHOW_FORBIDDEN_AIR Then
	Call view.newLine(-railWidth/2.0 - plateGap, 0, -railWidth/2.0 - plateGap, bottomForbiddenHeight)
	Call view.newLine(-railWidth/2.0 - plateGap, bottomForbiddenHeight, railWidth/2.0 + plateGap, bottomForbiddenHeight)
	Call view.newLine(railWidth/2.0 + plateGap, bottomForbiddenHeight, railWidth/2.0 + plateGap, 0)
	Call view.newLine(railWidth/2.0 + plateGap, 0, -railWidth/2.0 - plateGap, 0)

	Call view.newLine(-topForbiddenWidth/2.0, railHeight - flangeThickness - topForbiddenHeight, -topForbiddenWidth/2.0, railHeight - flangeThickness)
	Call view.newLine(-topForbiddenWidth/2.0, railHeight - flangeThickness, topForbiddenWidth/2.0, railHeight - flangeThickness)
	Call view.newLine(topForbiddenWidth/2.0, railHeight - flangeThickness, topForbiddenWidth/2.0, railHeight - flangeThickness - topForbiddenHeight)
	Call view.newLine(topForbiddenWidth/2.0, railHeight - flangeThickness - topForbiddenHeight, -topForbiddenWidth/2.0, railHeight - flangeThickness - topForbiddenHeight)

	Call view.getSlice().moveInALine(-airZ)

	Call view.selectAt(-1, bottomForbiddenHeight/2.0, infoSetSelection, Array(infoSliceSurface))
	Call view.makeComponentInALine(2.0*airZ, Array("Forbidden Air 1"), "Name=AIR", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
	Call getDocument().setMaxElementSize("Forbidden Air 1", airResolution)
	Call getDocument().setComponentColor("Forbidden Air 1", RGB(255, 0, 0), 50)

	Call view.selectAt(-1, railHeight - flangeThickness - topForbiddenHeight/2.0, infoSetSelection, Array(infoSliceSurface))
	Call view.makeComponentInALine(2.0*airZ, Array("Forbidden Air 2"), "Name=AIR", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
	Call getDocument().setMaxElementSize("Forbidden Air 2", airResolution)
	Call getDocument().setComponentColor("Forbidden Air 2", RGB(255, 0, 0), 50)

	Call view.getSlice().moveInALine(airZ)
	Call view.selectAll(infoSetSelection, Array(infoSliceLine))
	Call view.deleteSelection()
End If

' Magnets

Bx = -railClearance - webThickness/2.0
Ay = levitationHeight + 2.0*innerRadius*Sin(wheelAngle) + plateThickness
Ax = Bx - magnetWidth*Cos(wheelAngle + magnetAngle)
By = Ay + magnetWidth*Sin(wheelAngle + magnetAngle)
Cx = Bx - magnetDepth*Sin(wheelAngle + magnetAngle)
Cy = By + magnetDepth*Cos(wheelAngle + magnetAngle)
Dx = Ax - magnetDepth*Sin(wheelAngle + magnetAngle)
Dy = Ay + magnetDepth*Cos(wheelAngle + magnetAngle)

magnetMidX = (Ax + Bx + Cx + Dx) / 4.0
magnetMidY = (Ay + By + Cy + Dy) / 4.0

Px = -magnetWidth*Cos(wheelAngle + magnetAngle) - innerRadius*Cos(wheelAngle) - railClearance - webThickness/2.0
Py = innerRadius*Sin(wheelAngle) + levitationHeight + plateThickness
axisX = -Sin(wheelAngle)
axisY = Cos(wheelAngle)

outerRadius = innerRadius + magnetWidth*Cos(magnetAngle)

' Magnets

Call view.newLine(Ax, Ay, Bx, By)
Call view.newLine(Bx, By, Cx, Cy)
Call view.newLine(Cx, Cy, Dx, Dy)
Call view.newLine(Dx, Dy, Ax, Ay)

'Call view.newLine(Px, Py, Px + axisX*100, Py + axisY*100)

ReDim MagnetsA(numMagnets - 1)

Call view.getSlice().moveInAnArc(Px, Py, axisX, axisY, -360.0 / numMagnets / 2.0)

For i = 1 To numMagnets
	circleAngle = PI * 2.0 * (i - 1) / numMagnets 

	' Circumferential vector
	x1 = -Cos(wheelAngle)*Sin(circleAngle)
	y1 = -Sin(wheelAngle)*Sin(circleAngle)
	z1 = -Cos(circleAngle)

    ' Vector normal to outwards face
    x2 = Sin(wheelAngle + magnetAngle)*(Cos(circleAngle) + Sin(wheelAngle)*Sin(wheelAngle)*(1 - Cos(circleAngle))) + Cos(wheelAngle + magnetAngle)*Sin(wheelAngle)*Cos(wheelAngle)*(1 - Cos(circleAngle))
    y2 = -Sin(wheelAngle + magnetAngle)*Sin(wheelAngle)*Cos(wheelAngle)*(1 - Cos(circleAngle)) - Cos(wheelAngle + magnetAngle)*(Cos(circleAngle) + Cos(wheelAngle)*Cos(wheelAngle)*(1 - Cos(circleAngle)))
    z2 = -Sin(wheelAngle + magnetAngle)*Cos(wheelAngle)*Sin(circleAngle) + Cos(wheelAngle + magnetAngle)*Sin(wheelAngle)*Sin(circleAngle)

	magnetizationAngle = -(i - 1) * rollAngle

	x_hat = x1*Sin(magnetizationAngle) + x2*Cos(magnetizationAngle)
	y_hat = y1*Sin(magnetizationAngle) + y2*Cos(magnetizationAngle)
	z_hat = z1*Sin(magnetizationAngle) + z2*Cos(magnetizationAngle)

	direction = "[" & x_hat & "," & y_hat & "," & z_hat & "]"

	Call view.selectAll(infoSetSelection, Array(infoSliceSurface))

	Call view.makeComponentInAnArc(Px, Py, axisX, axisY, 360.0 / numMagnets, Array("Magnet#" & i), "Name=N50;Type=Uniform;Direction=" & direction, infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)

	Call getDocument().setMaxElementSize("Magnet#" & i, magnetResolution)
	Call getDocument().setMaxElementSize("Magnet#" & i & ",Face#4", magnetFaceResolution)

	Call view.getSlice().moveInAnArc(Px, Py, axisX, axisY, 360.0 / numMagnets)
	
	MagnetsA(i - 1) = "Magnet#" & i
Next

Call getDocument().shiftComponent(MagnetsA, offsetX, 0, 0, 1)

Call view.getSlice().moveInAnArc(Px, Py, axisX, axisY, 360.0 / numMagnets / 2.0)

if NOT(BUILD_WITH_SYMMETRY) Then
    Call view.getSlice().moveInAnArc(0, 0, 0, 1, 180.0)

    ReDim MagnetsB(numMagnets - 1)

    Call view.getSlice().moveInAnArc(Px, Py, axisX, axisY, 360.0 / numMagnets / 2.0)

    For i = 1 To numMagnets
        circleAngle = PI * 2.0 * (i - 1) / numMagnets 

        ' Circumferential vector
        x1 = Cos(wheelAngle)*Sin(circleAngle)
        y1 = -Sin(wheelAngle)*Sin(circleAngle)
        z1 = -Cos(circleAngle)

        ' Vector pointing outwards on magnet
        x2 = -Sin(wheelAngle + magnetAngle)*(Cos(circleAngle) + Sin(wheelAngle)*Sin(wheelAngle)*(1 - Cos(circleAngle))) - Cos(wheelAngle + magnetAngle)*Sin(wheelAngle)*Cos(wheelAngle)*(1 - Cos(circleAngle))
        y2 = -Sin(wheelAngle + magnetAngle)*Sin(wheelAngle)*Cos(wheelAngle)*(1 - Cos(circleAngle)) - Cos(wheelAngle + magnetAngle)*(Cos(circleAngle) + Cos(wheelAngle)*Cos(wheelAngle)*(1 - Cos(circleAngle)))
        z2 = -Sin(wheelAngle + magnetAngle)*Cos(wheelAngle)*Sin(circleAngle) + Cos(wheelAngle + magnetAngle)*Sin(wheelAngle)*Sin(circleAngle)

        magnetizationAngle = -(i - 1) * rollAngle + PI

		' Components of magnetization vector
        x_hat = x1*Sin(magnetizationAngle) + x2*Cos(magnetizationAngle)
        y_hat = y1*Sin(magnetizationAngle) + y2*Cos(magnetizationAngle)
        z_hat = z1*Sin(magnetizationAngle) + z2*Cos(magnetizationAngle)

        direction = "[" & x_hat & "," & y_hat & "," & z_hat & "]"
        
        Call view.selectAll(infoSetSelection, Array(infoSliceSurface))

        Call view.makeComponentInAnArc(Px, Py, axisX, axisY, -360.0 / numMagnets, Array("MagnetB#" & i), "Name=N50;Type=Uniform;Direction=" & direction, infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)

        Call getDocument().setMaxElementSize("MagnetB#" & i, magnetResolution)
        Call getDocument().setMaxElementSize("MagnetB#" & i & ",Face#4", magnetFaceResolution)

        Call view.getSlice().moveInAnArc(Px, Py, axisX, axisY, -360.0 / numMagnets)

        MagnetsB(i - 1) = "MagnetB#" & i
    Next

    Call getDocument().shiftComponent(MagnetsB, offsetX, 0, 0, 1)

    Call view.getSlice().moveInAnArc(Px, Py, axisX, axisY, -360.0 / numMagnets / 2.0)

    Call view.getSlice().moveInAnArc(0, 0, 0, 1, 180.0)
    Call view.selectAll(infoSetSelection, Array(infoSliceLine))
    Call view.deleteSelection()
End If

' Rail and plate(s)

If BUILD_WITH_SYMMETRY Then
	If SHOW_FULL_GEOMETRY Then
		Call view.newLine(-railWidth/2.0, 0, 0, 0)
		Call view.newLine(0, 0, 0, railHeight)
		Call view.newLine(0, railHeight, -railWidth/2.0, railHeight)
		Call view.newLine(-railWidth/2.0, railHeight, -railWidth/2.0, railHeight - flangeThickness)
		Call view.newLine(-railWidth/2.0, railHeight - flangeThickness, -webThickness/2.0, railHeight - flangeThickness)
		Call view.newLine(-webThickness/2.0, railHeight - flangeThickness, -webThickness/2.0, flangeThickness)
		Call view.newLine(-webThickness/2.0, flangeThickness, -railWidth/2.0, flangeThickness)
		Call view.newLine(-railWidth/2.0, flangeThickness, -railWidth/2.0, 0)
	Else
		Call view.newLine(-webThickness/2.0, plateThickness, 0, plateThickness)
		Call view.newLine(0, plateThickness, 0, railHeight - flangeThickness)
		Call view.newLine(0, railHeight - flangeThickness, -webThickness/2.0, railHeight - flangeThickness)
		Call view.newLine(-webThickness/2.0, railHeight - flangeThickness, -webThickness/2.0, plateThickness)
	End If
Else
	If SHOW_FULL_GEOMETRY Then
		Call view.newLine(-railWidth/2.0, 0, railWidth/2.0, 0)
		Call view.newLine(railWidth/2.0, 0, railWidth/2.0, flangeThickness)
		Call view.newLine(railWidth/2.0, flangeThickness, webThickness/2.0, flangeThickness)
		Call view.newLine(webThickness/2.0, flangeThickness, webThickness/2.0, railHeight - flangeThickness)
		Call view.newLine(webThickness/2.0, railHeight - flangeThickness, railWidth/2.0, railHeight - flangeThickness)
		Call view.newLine(railWidth/2.0, railHeight - flangeThickness, railWidth/2.0, railHeight)
		Call view.newLine(railWidth/2.0, railHeight, -railWidth/2.0, railHeight)
		Call view.newLine(-railWidth/2.0, railHeight, -railWidth/2.0, railHeight - flangeThickness)
		Call view.newLine(-railWidth/2.0, railHeight - flangeThickness, -webThickness/2.0, railHeight - flangeThickness)
		Call view.newLine(-webThickness/2.0, railHeight - flangeThickness, -webThickness/2.0, flangeThickness)
		Call view.newLine(-webThickness/2.0, flangeThickness, -railWidth/2.0, flangeThickness)
		Call view.newLine(-railWidth/2.0, flangeThickness, -railWidth/2.0, 0)
	Else
		Call view.newLine(-webThickness/2.0, plateThickness, webThickness/2.0, plateThickness)
		Call view.newLine(webThickness/2.0, plateThickness, webThickness/2.0, railHeight - flangeThickness)
		Call view.newLine(webThickness/2.0, railHeight - flangeThickness, -webThickness/2.0, railHeight - flangeThickness)
		Call view.newLine(-webThickness/2.0, railHeight - flangeThickness, -webThickness/2.0, plateThickness)
	End If
End If

Call view.newLine(-airX, 0, -railWidth/2.0 - plateGap, 0)
Call view.newLine(-railWidth/2.0 - plateGap, 0, -railWidth/2.0 - plateGap, plateThickness)
Call view.newLine(-railWidth/2.0 - plateGap, plateThickness, -airX, plateThickness)
Call view.newLine(-airX, plateThickness, -airX, 0)

If NOT(BUILD_WITH_SYMMETRY) Then
	Call view.newLine(airX, 0, railWidth/2.0 + plateGap, 0)
	Call view.newLine(railWidth/2.0 + plateGap, 0, railWidth/2.0 + plateGap, plateThickness)
	Call view.newLine(railWidth/2.0 + plateGap, plateThickness, airX, plateThickness)
	Call view.newLine(airX, plateThickness, airX, 0)
End If

Call view.getSlice().moveInALine(-airZ - motionLength/2.0)

Call view.selectAt(-1, railHeight/2.0, infoSetSelection, Array(infoSliceSurface))
Call view.makeComponentInALine(airZ*2 + motionLength, Array("Rail"), "Name=Aluminum: 3.8e7 Siemens/meter", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
Call getDocument().setMaxElementSize("Rail", aluminiumResolution)

Call view.selectAt(-railWidth-plateGap-10, plateThickness/2.0, infoSetSelection, Array(infoSliceSurface))
Call view.makeComponentInALine(airZ*2 + motionLength, Array("Plate1"), "Name=Aluminum: 3.8e7 Siemens/meter", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
Call getDocument().setMaxElementSize("Plate1", aluminiumResolution)

If NOT(BUILD_WITH_SYMMETRY) Then
	Call view.selectAt(railWidth+plateGap+10, plateThickness/2.0, infoSetSelection, Array(infoSliceSurface))
	Call view.makeComponentInALine(airZ*2 + motionLength, Array("Plate2"), "Name=Aluminum: 3.8e7 Siemens/meter", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
	Call getDocument().setMaxElementSize("Plate2", aluminiumResolution)
End If

Call view.getSlice().moveInALine(airZ + motionLength/2.0)
Call view.selectAll(infoSetSelection, Array(infoSliceLine))
Call view.deleteSelection()

If NOT(BUILD_WITH_SYMMETRY) Then
	If SHOW_FULL_GEOMETRY Then
		Call getDocument().setMaxElementSize("Rail,Face#6", railSurfaceResolution)
		Call getDocument().setMaxElementSize("Rail,Face#12", railSurfaceResolution)
	Else
		Call getDocument().setMaxElementSize("Rail,Face#4", railSurfaceResolution)
		Call getDocument().setMaxElementSize("Rail,Face#6", railSurfaceResolution)
	End If
Else
	If SHOW_FULL_GEOMETRY Then
		Call getDocument().setMaxElementSize("Rail,Face#8", railSurfaceResolution)
	Else
		Call getDocument().setMaxElementSize("Rail,Face#6", railSurfaceResolution)
	End If
End If

Call getDocument().setMaxElementSize("Plate1,Face#5", plateSurfaceResolution)

If NOT(BUILD_WITH_SYMMETRY) Then
	Call getDocument().setMaxElementSize("Plate2,Face#5", plateSurfaceResolution)
End If

' Magnet Motion

Call getDocument().makeMotionComponent(MagnetsA)
Call getDocument().setMotionSourceType("Motion#1", infoVelocityDriven)
Call getDocument().setMotionRotaryCenter("Motion#1", Array(Px, Py, 0))
Call getDocument().setMotionRotaryAxis("Motion#1", Array(axisX, axisY, 0))
Call getDocument().setMotionPositionAtStartup("Motion#1", 0)
' Call getDocument().setParameter("Motion#1", "SpeedAtStartup", "-(%rotSpeed)", infoNumberParameter)
Call getDocument().setParameter("Motion#1", "SpeedVsTime", "[0%ms, -(%rotSpeed)]", infoArrayParameter)

' Rail and Plate motions

Call getDocument().makeMotionComponent(Array("Rail"))
Call getDocument().setMotionSourceType("Motion#2", infoVelocityDriven)
Call getDocument().setMotionType("Motion#2", infoLinear)
Call getDocument().setMotionLinearDirection("Motion#2", Array(0, 0, 1))
Call getDocument().setMotionPositionAtStartup("Motion#2", -motionLength/2.0)
' Call getDocument().setMotionSpeedAtStartup("Motion#2", speed)
Call getDocument().setMotionSpeedVsTime("Motion#2", Array(0), Array(speed))
Call getDocument().setMotionLinearDirection("Motion#2", Array(0, 0, 1))

Call getDocument().makeMotionComponent(Array("Plate1"))
Call getDocument().setMotionSourceType("Motion#3", infoVelocityDriven)
Call getDocument().setMotionType("Motion#3", infoLinear)
Call getDocument().setMotionLinearDirection("Motion#3", Array(0, 0, 1))
Call getDocument().setMotionPositionAtStartup("Motion#3", -motionLength/2.0)
' Call getDocument().setMotionSpeedAtStartup("Motion#3", speed)
Call getDocument().setMotionSpeedVsTime("Motion#3", Array(0), Array(speed))
Call getDocument().setMotionLinearDirection("Motion#3", Array(0, 0, 1))

If NOT(BUILD_WITH_SYMMETRY) Then
	Call getDocument().makeMotionComponent(Array("Plate2"))
	Call getDocument().setMotionSourceType("Motion#4", infoVelocityDriven)
	Call getDocument().setMotionType("Motion#4", infoLinear)
	Call getDocument().setMotionLinearDirection("Motion#4", Array(0, 0, 1))
	Call getDocument().setMotionPositionAtStartup("Motion#4", -motionLength/2.0)
	' Call getDocument().setMotionSpeedAtStartup("Motion#4", speed)
	Call getDocument().setMotionSpeedVsTime("Motion#4", Array(0), Array(speed))
	Call getDocument().setMotionLinearDirection("Motion#4", Array(0, 0, 1))
End If

' 2nd wheel of magnets motion

If NOT(BUILD_WITH_SYMMETRY) Then
	Call getDocument().makeMotionComponent(MagnetsB)
	Call getDocument().setMotionSourceType("Motion#5", infoVelocityDriven)
	Call getDocument().setMotionRotaryCenter("Motion#5", Array(-Px, Py, 0))
	Call getDocument().setMotionRotaryAxis("Motion#5", Array(-axisX, axisY, 0))
	Call getDocument().setMotionPositionAtStartup("Motion#5", 0)
	' Call getDocument().setParameter("Motion#5", "SpeedAtStartup", "%rotSpeed", infoNumberParameter)
	Call getDocument().setParameter("Motion#5", "SpeedVsTime", "[0%ms, %rotSpeed]", infoArrayParameter)
End If


' Setup Simulation

Call getDocument().setTimeStepMethod(infoFixedIntervalTimeStep)
' Call getDocument().setFixedIntervalTimeSteps(0, solveStep*numSteps, solveStep)
' Call getDocument().deleteTimeStepMaximumDelta()
' Call getDocument().setAdaptiveTimeSteps(0, solveStep*numSteps, solveStep, solveStep * 4)
' Call getDocument().setTimeAdaptionTolerance(0.03)

Call getDocument().useHAdaption(useHAdaption)
Call getDocument().usePAdaption(usePAdaption)

Call getDocument().newPlanarSlice("SliceZ", Array(0, 0, 0), Array(0, 0, 1))
Call getDocument().newPlanarSlice("SliceX", Array(0, 0, 0), Array(1, 0, 0))
Call getDocument().newPlanarSlice("SliceY", Array(0, (Ay + By) / 2.0, 0), Array(0, 1, 0))

Dim text1

text1 = ""

If numSpeedSteps = 1 Then
	rps = (speed + slipSpeed) / (magneticCircumference)
    text1 = text1 & rps*2.0*PI & "%rad"
Else
    For i = 1 to numSpeedSteps
        slipSpeed = (i - 1) * ((maxSlipSpeed - minSlipSpeed) / (numSpeedSteps - 1)) + minSlipSpeed
        rps = (speed + slipSpeed) / (magneticCircumference)
        text1 = text1 & rps*2.0*PI & "%rad"
        If i <> numSpeedSteps Then
            text1 = text1 & ", "
        End If
    Next
End If

Call getDocument().setParameter("", "rotSpeed", text1, infoNumberParameter)
Call getDocument().setParameter("", "TimeSteps", "[0%ms, (1000.0/((%rotSpeed/(2.0*%Pi))*" & numMagnets & "*" & solveStepsPerMagnet & "))%ms, " & "(1000.0/((%rotSpeed/(2.0*%Pi))*" & numMagnets & "*" & solveStepsPerMagnet & ")*" & numSteps & ")%ms]", infoArrayParameter)

' Scale view to fit

Call getDocument().getView().setScaledToFit(True)

' Run Simulations

if runSimulation Then
	Call getDocument().solveTransient3DWithMotion()
End If