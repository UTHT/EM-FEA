function create_track(WIDTH_CORE,END_EXT,trackThickness,trackMaterial)

mi_drawrectangle(WIDTH_CORE/-2-END_EXT-100,trackThickness/-2,WIDTH_CORE/2+END_EXT+100,trackThickness/2);
mi_selectrectangle(WIDTH_CORE/-2-END_EXT-100,trackThickness/-2,WIDTH_CORE/2+END_EXT+100,trackThickness/2);
mi_setgroup(2);
mi_addblocklabel(0,0);
mi_selectlabel(0,0);
mi_setblockprop(trackMaterial,1,0,'<None>',0,2,0);
mi_clearselected;
