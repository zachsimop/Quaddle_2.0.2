
--APPLY MATERIAL TRANFORMATION. PARAMETERS: objbody - use name to determine angles and gizmo tranformation to height ratio

clearListener()
fileIn "FunctionsList.ms"

textureNum = 76
scaleSize = 50
NUM_OF_SHAPES = 8
DEFAULT_HR = 2
PYRIMIDAL_HR = 1.5
CO_HR = 2.5
DEFAULT_ANGLES = EulerAngles 90 -90 0 as quat
CUBIC_ANGLES = EulerAngles 90 -135 0 as quat



textureMainPath = "C:\\Users\\zachs\\Documents\\Lab\\Quaddle_2.0.2\\Quaddle_Generator\\Test Driver\\Assets & Object Table\\Assets\\"
fractalsMainPath = "C:\\Users\\zachs\\Documents\\Lab\\Quaddle_2.0.2\\Quaddle_Generator\\Test Driver\\Assets & Object Table\\Assets\\Fractals\\70_70_70\\"
vals = #("Circle_0.png","Circle_1.png","Cross_0.png","Cross_1.png",
							  "HourGlass_0.png","HourGlass_1.png","Square_0.png","Square_1.png",
							  "Raindrop_0.png","Raindrop_1.png","Triangle_0.png","Triangle_1.png",
							  "Leaf_0.png","Leaf_1.png")

Fvals =#()
j = 1
	while j < 95 do (
		
		filename = "F (" + (j as string) + ").png"
		append Fvals filename
		j = j+1
		
	)
	
maps = mapsInit()

max modify mode

makeBodies()

fn makeBodies
maps: maps Fvals: Fvals = (

iter = 1
	while iter < Fvals.count/9 do (

		shapeTexture= Bitmaptexture  fileName: (fractalsMainPath + Fvals[iter])	
		shapeMaterial = standardmaterial diffuseMap:(shapeTexture) showInViewport:true;
			
			for j =1 to NUM_OF_SHAPES do (
				print j
				print iter
				
				if j = 1 then (
					temp = makeCubicBody("None")
				)
				
				 if j = 2 then (
					temp = makeOblongBody("None")
				)
				
				 if j = 3 then (
					temp = makePyramidBody("None")
				)
				
				 if j = 4 then (
					temp = makeOctahedronBody("None")
				)
				
				 if j = 5 then (
					temp =  MakePepperBody("None")
				)
				
				 if j = 6 then (
					temp = MakeCompressedOblongBody("None")
				)
				
				 if j = 7 then (
					temp = MakeSphereBody("None")
				)
				
				 if j = 8 then (
					temp = MakeConcaveBody("None")
				)
				
				myshape =temp[2]
				
				select myshape
		-- 		print myshape.pos
		-- 		print (j*50)
		-- 		print (iter*50)
				myshape.pos = [0,(j*50),(iter*50)]
		-- 		print myshape.pos
				myshape.material = shapeMaterial
				
				if iter = 1 then (
					angleApp = DEFAULT_ANGLES
					hrApp = DEFAULT_HR

					if j = 1 then
						angleApp = CUBIC_ANGLES
					
					if j = 3 then
						hrApp = PYRIMIDAL_HR
					
					if j = 6 then
						hrApp = CO_HR
			
					
					addmodifier myshape maps[j] 
					maps[j].gizmo.rotation = angleApp
					maps[j].gizmo.position = [0,0,myshape.height/hrApp]
					
				)
				deselect myshape
				iter = iter + 1
			)
		)
)

fn mapsInit 
scaleSize: scaleSize = (
	
	returnArray = #()
	
	map0 = Uvwmap()
	append returnArray map0
	map1 = Uvwmap()
	append returnArray map1
	map2 = Uvwmap()
	append returnArray map2
	map3 = Uvwmap()
	append returnArray map3
	map4 = Uvwmap()
	append returnArray map4
	map5 = Uvwmap()
	append returnArray map5
	map6 = Uvwmap()
	append returnArray map6
	map7 = Uvwmap()
	append returnArray map7
	map8 = Uvwmap()
	append returnArray map8 
	
	for z = 1 to returnArray.count do (
		
		returnArray[z].length = scaleSize
		returnArray[z].height = scaleSize
		
	)
	
	return returnArray

)

max select all
