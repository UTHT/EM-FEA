function define_windings_toothwound_extended(SLOTS,SLOT_PITCH,copperMaterial,mediumMaterial,coilTurns,slotGap,slotTeethWidth,Hs2)

core_extension = 0;
width_core = 370;

for i=0:SLOTS-1
    delta=SLOT_PITCH*i;

    %We only use bWinding since the winding for both 
    %top and bottom are the same
    
    modulo = 2*mod(i+1,2)-1;

    lphase = mod(i,3);
    rphase = mod(i+1,3);

    lwinding = '';
    rwinding = '';
    
    if(lphase == 0)
        lwinding='WindingA';
    elseif(lphase == 1)
        lwinding='WindingB';
    else
        lwinding='WindingC';
    end

    if(rphase == 0)
        rwinding='WindingA';
    elseif(rphase == 1)
        rwinding='WindingB';
    else
        rwinding='WindingC';
    end


    mi_drawline(-slotTeethWidth/2+delta+slotGap/2,0,-slotTeethWidth/2+delta+slotGap/2,Hs2);
    
    mi_addblocklabel(-slotTeethWidth/2+delta+slotGap/4,Hs2*1/4);
    mi_selectlabel(-slotTeethWidth/2+delta+slotGap/4,Hs2*1/4);
    mi_setblockprop(copperMaterial,1,0,lwinding,0,1,coilTurns*modulo);
    mi_clearselected;

    mi_addblocklabel(-slotTeethWidth/2+delta+slotGap*3/4,Hs2*3/4);
    mi_selectlabel(-slotTeethWidth/2+delta+slotGap*3/4,Hs2*3/4);
    mi_setblockprop(copperMaterial,1,0,rwinding,0,1,coilTurns*modulo);
    mi_clearselected;
end

mi_drawline(-(width_core/2+core_extension+slotGap/2),0,-(width_core/2+core_extension+slotGap/2),Hs2);
mi_drawline(-(width_core/2+core_extension+slotGap/2),0,-(width_core/2+core_extension),0);
mi_drawline(-(width_core/2+core_extension+slotGap/2),Hs2,-(width_core/2+core_extension),Hs2);
mi_addblocklabel(-(width_core/2+core_extension+slotGap/4),Hs2*3/4);
mi_selectlabel(-(width_core/2+core_extension+slotGap/4),Hs2*3/4);
mi_setblockprop(copperMaterial,1,0,'WindingA',0,1,coilTurns*-1);
mi_clearselected;


mi_drawline((width_core/2+core_extension+slotGap/2),0,(width_core/2+core_extension+slotGap/2),Hs2);
mi_drawline((width_core/2+core_extension+slotGap/2),0,(width_core/2+core_extension),0);
mi_drawline((width_core/2+core_extension+slotGap/2),Hs2,(width_core/2+core_extension),Hs2);
mi_addblocklabel((width_core/2+core_extension+slotGap/4),Hs2*1/4);
mi_selectlabel((width_core/2+core_extension+slotGap/4),Hs2*1/4);
mi_setblockprop(copperMaterial,1,0,'WindingC',0,1,coilTurns*-1);
mi_clearselected;


mi_setblockprop(mediumMaterial,1,0,'<None>',0,0,0);
mi_clearselected;