'Geometry Parameters Setup'
width_core = 370      'core width (motion direction)
thick_core = 60       'core thickness (away from track)
length_core = 50      'core length (into the page)
core_endlengths = 30  'core end width
slots = 11            'number of slots
slot_pitch = 40       'slot pitch
slot_gap = 20         'slot gap width (teeth_width is generated with slot_pitch and slot_gap)
slot_height = 40      'slot height
end_ext = 15          'one sided winding extension value (TODO: replace with dynamic sizing)

const SHOW_FORBIDDEN_AIR = True		' Show forbidden zones for design purposes (as red air regions)
const SHOW_FULL_GEOMETRY = True		' Build with flanges of track
const BUILD_WITH_SYMMETRY = False	' Build only half of the track and one wheel, with symmetry conditions
const AUTO_RUN = False 'Run simulation as soon as problam definition is complete

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

'Winding Setup'
coil_core_separation_x = 4  'minimum separation between core and coil (one-sided, x-direction)'
coil_core_separation_y = 4  'minimum separation between core and coil (one-sided, y-direction)'
distribute_distance = 2     'distributed winding distance, in # of slots'

'Material Setup'
core_material = "M330-35A"
coil_material = "Copper: 5.77e7 Siemens/meter"
air_material = "AIR"

'Track Constants'
const railHeight = 127
const railWidth = 127
const webThickness = 10.4902
const flangeThickness = 10.4648
const plateThickness = 12.7
const plateGap = 12.7
const bottomForbiddenHeight = 29.6672
const topForbiddenHeight = 19.05
const topForbiddenWidth = 46.0502

'Internal Variables'
core_endlengths = core_endlengths + slot_gap
teeth_width = slot_pitch-slot_gap
slot_teeth_width = (slots-1)*slot_pitch+slot_gap
num_coils = slots-distribute_distance
coil_width = slot_gap-2*coil_core_separation_x
coil_height = (slot_height-3*coil_core_separation_y)/2


'Include Necessary Scripts'
Call Include("winding")
Call Include("core")
Call Include("track")

'Document Setup'
Call newDocument()
Call SetLocale("en-us")
Call getDocument().setDefaultLengthUnit("Millimeters")
Set view = getDocument().getView()



'Main Code'
Call make_core_component()
'Call make_windings(make_winding())
'Call make_track(SHOW_FORBIDDEN_AIR,SHOW_FULL_GEOMETRY,BUILD_WITH_SYMMETRY)

'end main'



Sub Include(file)
  Dim fso, f
  Set fso = CreateObject("Scripting.FileSystemObject")
  Set f = fso.OpenTextFile(file & ".vbs", 1)
  ExecuteGlobal f.ReadAll
  f.Close
  'ExecuteGlobal str
End Sub
