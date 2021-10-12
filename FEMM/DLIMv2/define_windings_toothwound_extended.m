function define_windings_toothwound_extended(SLOTS,SLOT_PITCH,copperMaterial,mediumMaterial,coilTurns,slotGap,slotTeethWidth,Hs2)

core_extension = 0;
width_core = 370;

for i=0:SLOTS-1
   delta=SLOT_PITCH*i;

   %We only use bWinding since the winding for both 
   %top and bottom are the same
   Phase = mod(i,12);
   modulo = 2*mod(i+1,2)-1;
   bWinding = '';
  
   if(Phase < 4)
       bWinding='WindingA';
   elseif(Phase < 8)
       bWinding='WindingB';
   else
       bWinding='WindingC';
   end

   %disp(bPhase)

   mi_drawline(-slotTeethWidth/2+delta+slotGap/2,0,-slotTeethWidth/2+delta+slotGap/2,Hs2);
    
end

mi_drawline(-(width_core/2+core_extension+slotGap/2),0,-(width_core/2+core_extension+slotGap/2),Hs2);
mi_drawline(-(width_core/2+core_extension+slotGap/2),0,-(width_core/2+core_extension),0);
mi_drawline(-(width_core/2+core_extension+slotGap/2),Hs2,-(width_core/2+core_extension),Hs2);

mi_drawline((width_core/2+core_extension+slotGap/2),0,(width_core/2+core_extension+slotGap/2),Hs2);
mi_drawline((width_core/2+core_extension+slotGap/2),0,(width_core/2+core_extension),0);
mi_drawline((width_core/2+core_extension+slotGap/2),Hs2,(width_core/2+core_extension),Hs2);


mi_setblockprop(mediumMaterial,1,0,'<None>',0,0,0);
mi_clearselected;