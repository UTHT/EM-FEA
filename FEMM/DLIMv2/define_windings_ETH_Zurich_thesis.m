function define_windings_ETH_Zurich_thesis(SLOTS,SLOT_PITCH,copperMaterial,mediumMaterial,coilTurns,slotGap,slotTeethWidth,Hs2)

for i=0:SLOTS-1
   delta=SLOT_PITCH*i;

   Phase = mod(i,12);
   modulo = 2*mod(i+1,2)-1;
   bWinding = '';
   tWinding = '';
  
   if(Phase < 4)
       bWinding='WindingA';
       tWinding='WindingA';
   elseif(Phase < 8)
       bWinding='WindingB';
       tWinding='WindingB';
   else
       bWinding='WindingC';
       tWinding='WindingC';
   end

   %disp(bPhase)

    mi_drawline(-slotTeethWidth/2+delta,Hs2/2,-slotTeethWidth/2+slotGap+delta,Hs2/2);
   
    mi_addblocklabel(-slotTeethWidth/2+slotGap/2+delta,Hs2*3/4);
    mi_selectlabel(-slotTeethWidth/2+slotGap/2+delta,Hs2*3/4);
    mi_setblockprop(copperMaterial,1,0,tWinding,0,1,coilTurns*modulo);
    mi_clearselected;
    mi_addblocklabel(-slotTeethWidth/2+slotGap/2+delta,Hs2*1/4);
    mi_selectlabel(-slotTeethWidth/2+slotGap/2+delta,Hs2*1/4);
    mi_setblockprop(copperMaterial,1,0,bWinding,0,1,coilTurns*modulo);
    mi_clearselected;
end

mi_addblocklabel(-slotTeethWidth/2+slotGap/2,Hs2*3/4);
mi_selectlabel(-slotTeethWidth/2+slotGap/2,Hs2*3/4);
mi_addblocklabel(-slotTeethWidth/2+slotGap/2+SLOT_PITCH,Hs2*3/4);
mi_selectlabel(-slotTeethWidth/2+slotGap/2+SLOT_PITCH,Hs2*3/4);

mi_addblocklabel(slotTeethWidth/2-slotGap/2,Hs2*1/4);
mi_selectlabel(slotTeethWidth/2-slotGap/2,Hs2*1/4);
mi_addblocklabel(slotTeethWidth/2-slotGap/2-SLOT_PITCH,Hs2*1/4);
mi_selectlabel(slotTeethWidth/2-slotGap/2-SLOT_PITCH,Hs2*1/4);

mi_setblockprop(mediumMaterial,1,0,'<None>',0,0,0);
mi_clearselected;