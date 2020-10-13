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
air_gap = 14          'distance between DLIM cores

'Problem Variables'
slip = 0.01         'Per unit slip'
v_r = 25            'Relative speed of pod'
motion_length = 1   'track_length (in meters)'
phase = 3           'Number of phases'

'Build Flags'
const SHOW_FORBIDDEN_AIR = False	  	' Show forbidden zones for design purposes (as red air regions)
const SHOW_FULL_GEOMETRY = False	   	' Build with flanges of track
const BUILD_WITH_SYMMETRY = False   	' Build only half of the track and one wheel, with symmetry conditions
const AUTO_RUN = False                ' Run simulation as soon as problam definition is complete

'Winding Setup'
coil_core_separation_x = 4  'minimum separation between core and coil (one-sided, x-direction)'
coil_core_separation_y = 4  'minimum separation between core and coil (one-sided, y-direction)'
distribute_distance = 2     'distributed winding distance, in # of slots'

'Material Setup'
core_material = "M330-35A"
coil_material = "Copper: 5.77e7 Siemens/meter"
track_material = "Aluminum: 3.8e7 Siemens/meter"
air_material = "AIR"

'Mesh Resolution Setup'
air_rail_boundary = 1
air_resolution = 6
aluminium_resolution = 5
rail_surface_resolution = 2
plate_surface_resolution = 3
use_H_adaption = False
use_P_adaption = False

'Track Constants'
const rail_height = 127
const rail_width = 127
const web_thickness = 10.4902
const flange_thickness = 10.4648
const plate_thickness = 12.7
const plate_gap = 12.7
const bottom_forbidden_height = 29.6672
const top_forbidden_height = 19.05
const top_forbidden_width = 46.0502

'Internal Variables'
core_endlengths = core_endlengths + slot_gap
teeth_width = slot_pitch-slot_gap
slot_teeth_width = (slots-1)*slot_pitch+slot_gap
core_track_gap = (air_gap-web_thickness)/2
num_coils = slots-distribute_distance
coil_width = slot_gap-2*coil_core_separation_x
coil_height = (slot_height-3*coil_core_separation_y)/2
v_s = v_r/(1-slip)
slip_speed = v_s-v_r
motion_length = motion_length*1000

'Problem Bounds'
x_min = 0
y_min = -20
z_min = -width_core*0.75
x_max = (length_core+air_gap)*2
y_max = rail_height+20
z_max = -z_min

'Document Setup'
Call newDocument()
Call SetLocale("en-us")
Call getDocument().setDefaultLengthUnit("Millimeters")
Set view = getDocument().getView()
Set app = getDocument().getApplication()


'Include Necessary Scripts'
Call Include("winding")
Call Include("core")
Call Include("track")
Call Include("air")
Call Include("identify")
Call Include("utils")
Call Include("build")
'Call Include("buildmotor")

'Ids Class Setup
Set ids_o = new ids.init()

'Main Code'

Call make_track(SHOW_FORBIDDEN_AIR,SHOW_FULL_GEOMETRY,BUILD_WITH_SYMMETRY)
'Call reset_local()
'Call print(ids_o.subtract_strings("Coil#1 Copy#1","Coil#1"))
Call build_motor()
'components = get_core_components(num_coils)
'Call getDocument().getApplication().MsgBox(components(0))
Call make_airbox(BUILD_WITH_SYMMETRY)
Set drivecirc = new circuit.init()


'end main'


Function build_single_side_core()
  Call make_core_component()
  Call make_single_side_windings(make_winding())
  Call make_single_side_coils()
  'Call print(ids_o.get_core_components())
End Function

Function orient_A()
  Call ids_o.update_names("A")
  components = ids_o.get_a_components()
  Call select_a_components()
  Call orient_core_a()
  Call move_core_to_midtrack(components)
  Call insert_core_airgap(components,1)
  Call getDocument().getView().unselectAll()
End Function

Function orient_B()
  Call ids_o.update_names("B")
  components = ids_o.get_b_components()
  Call select_b_components()
  Call orient_core_b()
  Call move_core_to_midtrack(components)
  Call insert_core_airgap(components,-1)
  Call getDocument().getView().unselectAll()
  For i = 1 to num_coils
    component_coil = "Coil#"&(i+num_coils)
    Call view.selectObject(component_coil, infoSetSelection)
    Call getDocument().reverseCoilDirection(component_coil)
  Next
End Function


Function build_motor()
  build_single_side_core()
  orient_A()
  If NOT (BUILD_WITH_SYMMETRY) Then
    build_single_side_core()
    orient_B()
  End If
End Function



Sub Include(file)
  Dim fso, f
  Set fso = CreateObject("Scripting.FileSystemObject")
  Set f = fso.OpenTextFile(file & ".vbs", 1)
  ExecuteGlobal f.ReadAll
  f.Close
End Sub
