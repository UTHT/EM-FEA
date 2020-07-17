function solve(THICK_CORE,Air,file_name)

mi_zoomnatural;
mi_addblocklabel(0,THICK_CORE*2);
mi_selectlabel(0,THICK_CORE*2);
mi_setblockprop(Air,1,0,'<None>',0,0,0);
mi_makeABC;
mi_saveas(file_name);
mi_analyze;
