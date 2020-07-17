function setup_materials(mediumMaterial,copperMaterial,trackMaterial,coreMaterial)

mi_getmaterial(mediumMaterial);
mi_getmaterial(copperMaterial);
mi_getmaterial(trackMaterial);
mi_getmaterial(coreMaterial);

mi_modifymaterial(coreMaterial,6,0.5);
