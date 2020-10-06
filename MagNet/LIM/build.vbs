Class build

  Private name
  Private final_name
  Private build_step
  Private component_number

  Public Default Function init(target_name)
    Call start_component_build(target_name)
    Set init = Me
  End Function

  Public Function start_component_build(target_name)
    name = "comp"
    final_name = target_name
    component_number=0
    build_step=0
  End Function

  Public Function update()
    temp_comps = up_complist()
    Call print(temp_comps)
  End Function

  Public Function union_all()
    temp_comps = up_complist()
    temp = temp_comps(0)
    For i=1 to UBound(temp_comps)
      Call union_components(temp,temp_comps(i))
      union_comps = ids_o.get_spec_components(Array("Union"))
      temp = component_name()
      Call rename_components(union_comps(0),temp)
    Next
    temp_comps = up_complist()
    Call rename_components(temp_comps(0),component_name())
  End Function

  Public Function mirror(normal)
    temp_comps = up_complist()
    Call mirror_components(temp_comps,normal)
  End Function

  Public Function mirror_copy(normal)
    temp_comps = up_complist()
    Call mirror_components_copy(temp_comps,normal)
  End Function

  Public Function end_component_build()
    temp_comps = up_complist()
    Call rename_components(temp_comps(0),final_name)
    end_component_build = final_name
  End Function

  Public Function component_name()
    component_name = name&component_number
    component_number=component_number+1
  End Function

  Public Function set_build_step(val)
    build_step = val
  End Function

  Public Function increment_step()
    build_step = build_step+1
  End Function

  Public Function get_build_step()
    get_build_step = build_step
  End Function

  Private Function up_complist()
    up_complist = ids_o.find_all_components_with_match_replace(Array(name))
  End Function

End Class
