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
y_min = -10
z_min = -width_core*0.75
x_max = (length_core+air_gap)*2
y_max = rail_height+10
z_max = -z_min

'Include Necessary Scripts'
Call Include("winding")
Call Include("core")
Call Include("track")
Call Include("air")

'Document Setup'
Call newDocument()
Call SetLocale("en-us")
Call getDocument().setDefaultLengthUnit("Millimeters")
Set view = getDocument().getView()

'Ids Class Setup
Set ids_o = new ids.init(num_coils)


'Main Code'

Call make_track(SHOW_FORBIDDEN_AIR,SHOW_FULL_GEOMETRY,BUILD_WITH_SYMMETRY)
Call ids_o.generate_core("test")
'Call reset_local()
'Call build_motor()
'components = get_core_components(num_coils)
'Call getDocument().getApplication().MsgBox(components(0))


'end main'


Function build_motor()
  Call make_core_component()
  Call make_single_side_windings(make_winding())
  Call select_core_components(num_coils)
  Call orient_core(num_coils)
  Call move_core_to_midtrack(num_coils)
  Call insert_core_airgap(num_coils)
  If NOT (BUILD_WITH_SYMMETRY) Then
    Call mirror_components()
  End If
End Function


Sub Include(file)
  Dim fso, f
  Set fso = CreateObject("Scripting.FileSystemObject")
  Set f = fso.OpenTextFile(file & ".vbs", 1)
  ExecuteGlobal f.ReadAll
  f.Close
End Sub


Class ids
  Private num_coils
  Private mirror

  Private component_names
  Private component_names_a
  Private component_names_b

  'Constructor
  Public Default Function init(nc)
    num_coils = nc
    component_names = Array()
    component_names_a = Array()
    component_names_b = Array()

    Set init = Me
  End Function

  Public Function generate_core(name)
    Call getDocument().getApplication().MsgBox(UBound(component_names))
    ReDim Preserve component_names(UBound(component_names) + 1)
    component_names(UBound(component_names)) = name
    Call getDocument().getApplication().MsgBox(UBound(component_names))
  End Function

  Public Property Get a_component_names()
    a_component_names = component_names_a
  End Property

  Public Property Get b_component_names()
    b_component_names = component_names_b
  End Property

End Class
