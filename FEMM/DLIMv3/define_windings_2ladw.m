function define_windings_2ladw(SLOTS,SLOT_PITCH,copperMaterial,mediumMaterial,coilTurns,slotGap,slotTeethWidth,Hs2)

for i=0:SLOTS-1
   delta=SLOT_PITCH*i;

   bPhase = mod(i,3);
   tPhase = mod(i+1,3);
   bmodulo = 2*mod(i+1,2)-1;
   tmodulo = 2*mod(i+2,2)-1;
   bWinding = '';
   tWinding = '';

   if(bPhase==0)
       bWinding='WindingA';
   elseif(bPhase==1)
       bWinding='WindingB';
   elseif(bPhase==2)
       bWinding='WindingC';
   end

   if(tPhase==0)
       tWinding='WindingA';
   elseif(tPhase==1)
       tWinding='WindingB';
   elseif(tPhase==2)
       tWinding='WindingC';
   end
   %disp(bPhase)

   mi_drawline(-slotTeethWidth/2+delta,Hs2/2,-slotTeethWidth/2+slotGap+delta,Hs2/2);
   if(~(i==0||i==1))
        mi_addblocklabel(-slotTeethWidth/2+slotGap/2+delta,Hs2*3/4);
        mi_selectlabel(-slotTeethWidth/2+slotGap/2+delta,Hs2*3/4);
        mi_setblockprop(copperMaterial,1,0,tWinding,0,1,coilTurns*tmodulo);
        mi_clearselected;
   end
   if(~(i==SLOTS-1||i==SLOTS-2))
        mi_addblocklabel(-slotTeethWidth/2+slotGap/2+delta,Hs2*1/4);
        mi_selectlabel(-slotTeethWidth/2+slotGap/2+delta,Hs2*1/4);
        mi_setblockprop(copperMaterial,1,0,bWinding,0,1,coilTurns*bmodulo);
        mi_clearselected;
   end
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
