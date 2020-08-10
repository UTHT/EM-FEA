'Geometry Parameters Setup'

Dim width_core 'core width (motion direction)
Dim thick_core 'core thickness (away from track)
Dim length_core 'core length (into the page)
Dim core_endlengths 'core end width

Dim slots 'number of slots'
Dim slot_pitch 'slot pitch'
Dim slot_gap 'slot gap width'
Dim teeth_width 'teeth width'
Dim slot_height 'slot height'
Dim end_ext

width_core = 370
thick_core = 60
length_core = 50
core_endlengths = 30
slots = 11
slot_pitch = 40
slot_gap = 20
slot_height = 40
end_ext = 15


'Winding Setup'
Dim coil_core_separation_x 'minimum separation between core and coil (one-sided, x-direction)'
Dim coil_core_separation_y 'minimum separation between core and coil (one-sided, y-direction)'
Dim distribute_distance 'distributed winding distance, in # of slots'

Dim coil_width 'coil x length value'
Dim coil_height 'coil y length value'

coil_core_separation_x = 4
coil_core_separation_y = 4
distribute_distance = 2


'Internal Variables'
core_endlengths = core_endlengths + slot_gap
teeth_width = slot_pitch-slot_gap
slot_teeth_width = (slots-1)*slot_pitch+slot_gap
num_coils = slots-distribute_distance
coil_width = slot_gap-2*coil_core_separation_x
coil_height = (slot_height-3*coil_core_separation_y)/2


'Material Setup'
Dim core_material
Dim air_material

core_material = "M330-35A"
coil_material = "Copper: 5.77e7 Siemens/meter"
air_material = "AIR"

'Include Necessary Scripts'
Call Include("winding")
Call Include("core")

'Document Setup'
Call newDocument()
Call SetLocale("en-us")
Call getDocument().setDefaultLengthUnit("Millimeters")
Set view = getDocument().getView()




'main()'
Call view.getSlice().moveInALine(-length_core/2)
Call make_core_component()
Call make_windings(make_winding())


'end main'


Sub Include(file)

  Dim fso, f
  Set fso = CreateObject("Scripting.FileSystemObject")
  Set f = fso.OpenTextFile(file & ".vbs", 1)
  ExecuteGlobal f.ReadAll
  f.Close
  'ExecuteGlobal str
End Sub
