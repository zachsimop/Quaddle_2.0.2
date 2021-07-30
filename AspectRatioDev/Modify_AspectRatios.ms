cleanlistener()

textureMainPath = "C:\\Users\\zachs\\Documents\\Lab\\Quaddle_2.0.2\\AspectRatioDev\\Assests & Object Table\\Assets\\Icons\\"
vals = #("Circle_0.png","Circle_1.png","Cross_0.png","Cross_1.png",
							  "HourGlass_0.png","HourGlass_1.png","Square_0.png","Square_1.png",
							  "Raindrop_0.png","Raindrop_1.png","Triangle_0.png","Triangle_1.png",
							  "Leaf_0.png","Leaf_1.png")

							  
fileIn "FunctionsList.ms"
							  
	  map0 = Uvwmap()
	  map1 = Uvwmap()
	  map2 = Uvwmap()
	  map3 = Uvwmap()
	  map4 = Uvwmap()
	  map5 = Uvwmap()
	  map6 = Uvwmap()
	  map7 = Uvwmap()
	  map8 = Uvwmap()
	  map9 = Uvwmap()
							  
for i = 1 to vals.count do (
	
	shapeTexture= Bitmaptexture  fileName: (textureMainPath + vals[i])	
	shapeMaterial = standardmaterial diffuseMap:(shapeTexture) showInViewport:true;
	temp = makeCubicBody("None")
	myshape =temp[2]
	myshape.pos = [0,i*40,0]
	myshape.material = shapeMaterial
	addmodifier myshape map0
	temp = makeOblongBody("None")
	myshape =temp[2]
	myshape.pos = [0,i*40,45]
	addmodifier myshape map1
	myshape.material = shapeMaterial
	temp = makePyramidBody("None")
	myshape =temp[2]
	myshape.pos = [0,i*40,90]
	addmodifier myshape map2
	myshape.material = shapeMaterial
	temp = makeOctahedronBody("None")
	myshape =temp[2]
	myshape.pos = [0,i*40,135]
	addmodifier myshape map3
	myshape.material = shapeMaterial
	temp = makeDumbbellBody("None")
	myshape =temp[3]
	myshape.pos = [0,i*40,180]
	addmodifier myshape map4
	myshape.material = shapeMaterial
	temp = makeConvexBody("None")
	myshape =temp[3]
	myshape.pos = [0,i*40,225]
	addmodifier myshape map5
	myshape.material = shapeMaterial
	temp = MakePepperBody("None")
	myshape =temp[3]
	myshape.pos = [0,i*40,270]
	addmodifier myshape map6
	myshape.material = shapeMaterial
	temp = MakeCompressedOblongBody("None")
	myshape =temp[2]
	myshape.pos = [0,i*40,315]
	addmodifier myshape map7
	myshape.material = shapeMaterial
	temp = MakeSphereBody("None")
	myshape =temp[2]
	myshape.pos = [0,i*40,360]
	addmodifier myshape map8
	myshape.material = shapeMaterial
	temp = MakeConcaveBody("None")
	myshape =temp[2]
	myshape.pos = [0,i*40,405]
	addmodifier myshape map9
	myshape.material = shapeMaterial
)

-- max select all
-- subobjectLevel = 1
-- modPanel.setCurrentObject $Box001.modifiers[#UVW_Map]

-- applyTransformations(map0)
-- applyTransformations(map1)
-- applyTransformations(map2)
-- applyTransformations(map3)
-- applyTransformations(map4)
-- applyTransformations(map5)
-- applyTransformations(map6)
-- applyTransformations(map7)
-- applyTransformations(map8)
-- applyTransformations(map9)

-- fn applyTransformations
-- map = (
-- 	mygiz = $.modifiers.map.gizmo subAnim
-- 	mygiz.position [-1,10,0]
