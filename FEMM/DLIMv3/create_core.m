function create_core(WIDTH_CORE,END_EXT,THICK_CORE,SLOT_PITCH,SLOTS,slotTeethWidth,slotGap,Hs2)

%Define LIM core external dimensions
mi_addnode(WIDTH_CORE/-2-END_EXT,THICK_CORE);
mi_addnode(WIDTH_CORE/2+END_EXT,THICK_CORE);
mi_addnode(WIDTH_CORE/-2-END_EXT,0);
mi_addnode(WIDTH_CORE/2+END_EXT,0);

mi_addsegment(WIDTH_CORE/-2-END_EXT,THICK_CORE,WIDTH_CORE/2+END_EXT,THICK_CORE);
mi_addsegment(WIDTH_CORE/-2-END_EXT,0,WIDTH_CORE/-2-END_EXT,THICK_CORE);
mi_addsegment(WIDTH_CORE/2+END_EXT,0,WIDTH_CORE/2+END_EXT,THICK_CORE);

%Define teeth geometries
for i=0:SLOTS-1
    delta = SLOT_PITCH*i;
    mi_drawline(-slotTeethWidth/2+delta,0,-slotTeethWidth/2+delta,Hs2);
    mi_drawline(-slotTeethWidth/2+slotGap+delta,0,-slotTeethWidth/2+slotGap+delta,Hs2);
    %This line draws a horizontal across the very top and bottom of the
    %core. Since we are only working with one layer, we don't need it.
    mi_addsegment(-slotTeethWidth/2+delta,Hs2,-slotTeethWidth/2+delta+slotGap,Hs2);
end

%for i=0:SLOTS-2
%    delta=SLOT_PITCH*i;
%    mi_addsegment(-slotTeethWidth/2+slotGap+delta,0,-slotTeethWidth/2+slotGap+delta+Bs1,0);
%end

mi_addsegment(WIDTH_CORE/-2-END_EXT,0,-slotTeethWidth/2,0);
mi_addsegment(slotTeethWidth/2,0,WIDTH_CORE/2+END_EXT,0);
