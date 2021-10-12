function save_bitmap(WIDTH_CORE,END_EXT,file_name)

plotUpperLimit = 1;
plotLowerLimit = 0.0;
paddingRatio = 1;

leftBound = (WIDTH_CORE/-2-END_EXT-100)*paddingRatio;
rightBound = (WIDTH_CORE/2+END_EXT+100)*paddingRatio;
topBound = (100)*paddingRatio;
botBound = -(150)*paddingRatio;
mo_showdensityplot(0,0,plotUpperLimit,plotLowerLimit,'real');
mo_zoom(leftBound,botBound,rightBound,topBound);
mo_savebitmap(file_name)
