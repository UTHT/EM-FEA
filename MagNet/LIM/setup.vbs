Sub setup()
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
End Sub
