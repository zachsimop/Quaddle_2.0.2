-- Attention-Circuits-Control L
--Laboratory (www.attention-circuits-control.org) --

--For more information on how Quaddles are generated and may be used:
--Watson, MR., Voloh, B., Naghizadeh, M., Womelsdorf, T., (2018) “Quaddles: A multidimensional 3D object set with parametrically-controlled
-- and customizable features” Behav Res Methods.

--Website guide: http://accl.psy.vanderbilt.edu/resources/analysis-tools/3d-image-material/
--Brief instructions on how to use scripts: http://accl.psy.vanderbilt.edu/quaddlegenerator-brief-instructions/

--Scripts, objects and in depth manual available on github: https://github.com/att-circ-contrl/Quaddles-Gen

--FUNCTIONS LIST
FileIn "Helper_Functions.ms"

fn generateObjects dimCount = (
	
	allObjects = #()
	numOfObjects = 0
	
	for valCount = 1 to Vals[dimCount].count do(
		
		objVals[dimCount] = Vals[dimCount][valCount]
		
		if dimCount != Vals.count then
			generateObjects(dimCount+1)
		
		else if dimCount == Vals.count then
		(
			if userWantsPics or userWantsFBX then
				Obj = makeObject()
			
			if userWantsPics then
				TakePics(Obj)(0)(camDistance)
			if userWantsFBX then
				ExportObject()
			
			if userWantsPics or userWantsFBX then
				delete Obj
			
			numOfObjects = numOfObjects + 1
			temp = copy objVals #nomap
			allObjects[numOfObjects] = temp	
		
		)
	)
	print allObjects
)

--MAIN FUNCTION FOR MAKING OBJECTS--
fn MakeObject 
Dims:Dims objVals:objVals assetPath:assetPath  percentages: percentages dimCount: dimCount
transparencyAmount:transparencyAmount = (
	--Description: Main function for making and saving objects
	--Input: pretty much all variables from the MainScript script
	--Example Call: MakeObject() will create a given object defined by its features in "objvals"

--bodyType used in Body generation. Used to Avoid unecessary calls
	bodyType = objVals[1]

	--Ensure Dimensions are labeled correctly
	if findItem Dims "Color" != 0 do
		Dims[findItem Dims "Color"] = "Colour"


	if findItem Dims "Arms" != 0 do
		Dims[findItem Dims "Arms"] = "Arm_Angle"

	--qArray is simply an array of all the components which will comprise of the quaddle
	qArray = #()

--BODY GENERATION
	
	if objHasAspectRatio() then (
		
		if ( aspectRatioVal() == "Null") then (
			ratio = 0
			camDistance = 150
		)
		
		if ( aspectRatioVal() == "Long") then (
			ratio = 0.3
			camDistance = 200
		)
		
		if ( aspectRatioVal() == "Short") then (
			ratio = -0.2
			camDistance = 125
		)
		
	) else (
		
		ratio = 0
		
	)
	
	bodyResult = MakeBody(bodyType)
	objbody = bodyResult[1]
	polygonner = bodyResult[2]
	qArray = bodyResult[3]
	SmoothenEdges(objbody)
	
	bodyZMax = objBody.max[3]
	
	textureResult = ApplyTexture(objbody)
	assetPath = textureResult[1]
	map = textureResult[2]
	objbody = textureResult[3]
	outMap = textureResult[4]

	if objHasIcon()  do (

		iconPath = assetPath + "Icons\\" + iconVal()
		mat = Bitmaptexture filename:(iconPath)
		objbody.material = standardMaterial diffuseMap:(mat)
		myMap = uvwmap() 
		myMap.length = SCALE_SIZE
		myMap.width = SCALE_SIZE
		myMap.height = SCALE_SIZE
		
		max modify mode
		select objbody
		hrApp = DEFAULT_HR; angleApp = DEFAULT_ANGLES
		if bodyType == "Cubic" then
			angleApp = CUBIC_ANGLES
		else if bodyType == "Pyrimidal" then
			hrApp = PYRIMIDAL_HR
		else if bodyType == "Compressed_Oblong" then
			hrApp = CO_HR
		

		addmodifier objbody myMap 
		myMap.gizmo.rotation = angleApp
		myMap.gizmo.position = [0,0,objbody.height/hrApp]
		deselect objbody

	)
		
	if objHasFractal() then (
	
		FractalPath = assetPath + "Fractals\\" + greyColour + "\\" + fractalVal() 
		mat = Bitmaptexture filename:(FractalPath)
		objbody.material = standardMaterial diffuseMap:(mat)
		myMap = uvwmap() 
		myMap.length = SCALE_SIZE
		myMap.width = SCALE_SIZE
		myMap.height = SCALE_SIZE
		
		max modify mode
		select objbody
		hrApp = DEFAULT_HR; angleApp = DEFAULT_ANGLES
		if bodyType == "Cubic" then
			angleApp = CUBIC_ANGLES
		else if bodyType == "Pyrimidal" then
			hrApp = PYRIMIDAL_HR
		else if bodyType == "Compressed_Oblong" then
			hrApp = CO_HR


		addmodifier objbody myMap 
		myMap.gizmo.rotation = angleApp
		myMap.gizmo.position = [0,0,objbody.height/hrApp]
		deselect objbody

	)

-- HEAD GENERATION
	if objHasHead() do (
		
		if ( headVal()  != "No Head" ) then (
			
			if applyAspectRatioToHead == false then
				ratio = 0
			
			headResult = MakeBody( headVal() )
			headBody = headResult[1]
			
			headTextureResult = ApplyTexture(headBody)
			assetPath = headTextureResult[1]
			headMap = headTextureResult[2]
			headBody = headTextureResult[3]
			headoutMap = headTextureResult[4]
			
			scale headBody [0.5,0.5,0.5]
			
			hBodyZMax = headBody.max[3]
			
			headBody.pos = [0, 0 , (bodyZMax + hBodyZMax) - 0.1]			
			SmoothenEdges(headBody)
			
		)
	)

	if ( objHasBeak() and headVal() != "No Head") do (
		isBeak = true
		beakResult = makeArms()
		qArray = beakResult[2]
	)

--ARM GENERATION
	if (objHasArmAngle())  or (objHasArmAngle()) do (
		
		isBeak = false
		armResult = MakeArms()
		listOfArms = armResult[1] 
		qArray = armResult[2]
		
	)
	
	nameVal = nameVal + 1
	objName = "Object_" + nameVal as String
	group (qArray as array) name: objName
	
	return qArray
)

fn MakeBody 
body objName:objName percentages: percentages ratio: ratio
Dims: Dims Vals:Vals qArray:qArray = (
	
	--Description: Creates main body of objects. Accesses appropriate scripts for specific body
	--Input: requires object values, and object percentages for custom "amalgam" bodies
	--Outputs: Creates main body
	--Example Call: MakeBodies("Cubic") will make the cubic body
		
	
	if ( objHasPattern() ) then 
		local pattern = patternVal()
	else
			local pattern = "None"
		
	if (body == "Oblong") then (
		
		bodyResult = MakeOblongBody(pattern)
		controlPoint = bodyResult[1]
		objbody = bodyResult[2]
		polygonner = bodyResult[3]
		
	)
		
	else if (body == "Pyramidal") then (
		
		bodyResult = MakePyramidBody(pattern)
		controlPoint = bodyResult[1]
		objbody = bodyResult[2]
		polygonner = bodyResult[3]
		
	)
		
	else if (body == "Concave") then (
		
		bodyResult = MakeConcaveBody(pattern)
		controlPoint = bodyResult[1]
		objbody = bodyResult[2]
		polygonner = bodyResult[3]
		
	)
		
	else if (body == "Octahedron") then (
		
		bodyResult = MakeOctahedronBody(pattern)
		controlPoint = bodyResult[1]
		objbody = bodyResult[2]
		polygonner = bodyResult[3]
		
	)
		
	else if (body == "Cubic") then (
		
		bodyResult = MakeCubicBody(pattern)
		controlPoint = bodyResult[1]
		objbody = bodyResult[2]
		polygonner = bodyResult[3]
		
	)
		
	else if (body == "Dumbbell") then (
		
		bodyResult = MakeDumbbellBody(pattern)
		controlPoint = bodyResult[1]
		secondControlPoint = bodyResult[2]
		objbody = bodyResult[3]
		reflector = bodyResult[4]
		polygonner = bodyResult[5]
		
	)
		
	else if (body == "Convex") then (
		
		bodyResult = MakeConvexBody(pattern)
		controlPoint = bodyResult[1]
		secondControlPoint = bodyResult[2]
		objbody = bodyResult[3]
		polygonner = bodyResult[4]
		
	)
		
	else if (body == "Pepper") then (
		
		bodyResult = MakePepperBody(pattern)
		controlPoint = bodyResult[1]
		secondControlPoint = bodyResult[2]
		objbody = bodyResult[3]
		polygonner = bodyResult[4]
		
	)
		
		--compressedOblongOutput = #(controlPoint,objbody,squisher,polygonner2)
	else if (body == "Compressed_Oblong") then (
		
		bodyResult = MakeCompressedOblongBody(pattern)
		controlPoint = bodyResult[1]
		objbody = bodyResult[2]
		squisher = bodyResult[3]
		polygonner = bodyResult[4]
		
	)	
		
	else if (body == "Sphere") then (
		
		bodyResult = MakeSphereBody(pattern)
		controlPoint = bodyResult[1]
		objbody = bodyResult[2]
		polygonner = bodyResult[3]
		
	)
		
	else if (body == "Custom") then (
		
		bodyResult = MakeCustomAmalgamBody(pattern)(pyramidpercentage) \
		(oblongpercentage)(concavepercentage)(octahedronpercentage)(cubepercentage)(spherepercentage)
		controlPoint = bodyResult[1]
		objbody = bodyResult[2]
		polygonner = bodyResult[3]
		
	)

	--Giving object main bodies names
	--objbody.name = objName + "_Body"
	
	append qArray objbody

	bodyOutput = #(objbody,polygonner,qArray)
	return bodyOutput
		
-- 	return objbody
-- 	return polygonner
-- 	return qArray
		
)

fn ApplyTexture 
objbody 
assetPath:assetPath Dims:Dims Vals:Vals objvals:objvals =
(
	--Description: Applies texture to main body of object
	--Input: objbody (main object body), assetPath(texture and folder path to be applied), Dims(object dimensions), Vals, objvals(
	--Example Call: ApplyTexture(objbody)("C://Person//Documents//Patterns//Pattern(Diamond)+Colour(Blue)") will apply the blue diamond pattern to the "objbody" object
	
	pcPath = assetPath + "Patterns and Colours\\"
	
	if greyColour == "180_180_180" then
		greyColour = greyColour + ".png"
	
	if (findItem Dims "Pattern_Inversion" != 0) then (
		
		if  (objVals[findItem Dims "Pattern_Inversion"] == "Inverted") then 
			invertText = "_inv"
		else 
			invertText = ""
		
	) else 
		invertText = ""
	
	
	if  objHasPattern()  and objHasColour()  then (

		if patternVal() == "No Pattern" then (
			
			if colourVal() == "Grey" then
				texturePath = pcPath + greyColour
			else
				texturePath = pcPath + "Colour(" + colourVal() + ").png"
		)
		else
			texturePath= pcPath + "Pattern(" + patternVal() + ")+Colour(" + colourVal() + ")" + invertText + ".png"
	
	)
	
	else if objDoesNotHavePattern() and objDoesNotHaveColour() then 
		texturePath= pcPath + greyColour

	else if objHasPattern() and objDoesNotHaveColour() then (
		
		if patternVal() == "No Pattern" then
			texturePath= pcPath + greyColour
		else
			texturePath= pcPath + "Pattern(" + patternVal() + ")+Colour(Grey)" +  invertText + ".png"
		
	)
	
	else if objDoesNotHavePattern() and objHasColour() then (
		
		if colourVal() == "Grey" then
			texturePath = pcPath + greyColour
		else
			texturePath = pcPath + "Colour(" + colourVal() + ")" + invertText + ".png"
		
	)
	
	if greyColour == "180_180_180.png" then
		greyColour = "180_180_180"
	
	body = bodyVal()
	
	--APPLYING PROPER WRAPPING	
	--uv map allows textures to be properly rendered onto object in appropriate way
	--over here--
	map = uvwmap()

	if (body == "Oblong") then (
	--indicates spherical uvw mapping to be used
	map.maptype = 2
	)
	else (
	--indicates cylindrical uvw mapping to be used
	map.maptype = 1
	)
	map.length = 40
	map.width = 40

	if (body == "Concave") then
	(
		if (pattern == "Polka") then
		(
			map.length = 80	
			map.width = 80		
			map.height = 120			
			map.utile = 1
			map.vtile = 1
			map.cap = true
			addmodifier objbody map
		)
		else if (pattern == "Squiggly") then
		(
			map.maptype = 2
			map.height = 40
			map.utile = 2.5
			map.vtile = 2.5
			addmodifier objbody map
		)
		else if (pattern == "Diamond") then
		(
			map.height= 110
			addmodifier objbody map
		)
		else (
			map.height= 60
			addmodifier objbody map
		)
	)
	else if (body == "Compressed_Oblong") then
	(
		if (pattern == "Checkered") then
		(
			map.length = 50
			map.width = 50		
			map.height = 55			
			map.utile = 1.5
			map.vtile = 1
			map.cap = false
			addmodifier objbody map
		)
		else if (pattern == "Diamond") then
		(
			map.length = 50
			map.width = 50		
			map.height = 75			
			map.utile = 1.5
			map.vtile = 1
			map.cap = false
			addmodifier objbody map
		)
		else (
			map.length = 50
			map.width = 50		
			map.height = 55			
			map.utile = 1.5
			map.vtile = 1
			map.cap = false
			addmodifier objbody map
		)
	)
	else if (pattern == "Checkered") then
	(
		map.height = 60
		addmodifier objbody map
	)
	else if (pattern == "Diamond") then
	(
		map.height = 100
		addmodifier objbody map
	)
	else 
	(
		map.height= 40
		addmodifier objbody map
	)

	--ACTUALLY APPLYING THE TEXTURE
	--putting material on texture
	outMap = Bitmaptexture  fileName: (texturePath)
-- 	ccnode = Color_Correction()
-- 	ccnode map outMap
-- 	ccnode rewireMode 1
	objbody.material = standardMaterial diffuseMap:(outMap) showInViewport:true;
	
	textureOutput = #(assetPath,map,objbody,outMap)
	return textureOutput
-- 	return assetPath
-- 	return map
-- 	return objbody
-- 	return outMap
 )

fn MakeArms 
isBeak: isBeak Dims: Dims objVals:objVals objName:objName objbody:objbody = 
(
	--Description: Makes Arms
	--Input: arms(specific kind of arms to be made), objName (the name of the object)
	--Outputs: Creates arms
	--Example Call: MakeArms("Bent_Up")("Body(Oblong)+Arms(Bent_Up)") will add arms to the object thead are bent upwards
	
	
	if( isBeak ) then (
		
		if objHasBeakAngle() then 
			arms = beakAngleVal()
		else 
			arms = "Straight"

		if objHasBeakEnds() then 
			armEnds = beakEndsVal()
		else 
			armEnds = "Flat"

	) else (
		
		if objHasArmAngle() then 
			arms = armAngleVal()
		else 
			arms = "Straight"
		
		if objHasArmEnds() then 
			armEnds = armEndsVal()
		else 
			armEnds = "Flat"
		
		--the number of arms on the object is specificied by "ArmCount". If it's not present then the number of arms is set to 4
		if objHasArmCount() then (
			
			if  armCountVal() == "1L" or armCountVal() == "1R" then (
				
			armString = armCountVal()
			if armString[2] == "L" then 
				genLeft = true
			else 
				genLeft = false
			
			numberOfArms = armString[1] as integer
			
			)	
			else
				numberOfArms = armCountVal() as integer
			
			if (keepIandFVisible and numberOfArms > 3) and ( objHasFractal()  or  objHasIcon() ) then 
				numberOfArms = 2
		)
	)	
	--if Arms are spherical, we can right away make them, if not we have to specificy some other values
	if (arms == "Spherical") or (armEnds == "Spherical") then (listOfArms = MakeSphericalArms(objName)(numberOfArms)(objbody)(body))
	else (
		
		if (arms == "Bent_Down") then (bendAngle = 45)
		else if (arms == "Bent_Up") then (bendAngle = -45)
		else if (arms == "Straight") then (bendAngle = 0)
		else (bendAngle = 0);
		
		if (armEnds == "Blunt") then (
			endradius = 2 ; startradius = 6;
		)
		else if (armEnds == "Pointed") then (
			endradius = 0; startradius = 6;
		)
		else if (armEnds == "Flared") then (
			endradius = 5; startradius = 2;
		)
		else if (armEnds == "Flat") then (
			endradius = 4; startradius = 4;
		)
		else (
			endradius = 4; startradius = 4;
			)		

		--MakeAlternativeArms is the actual function thead makes the arms
		listOfArms = MakeAlternativeArms(bendAngle)(startradius)(endradius)(objName)(numberOfArms)(genLeft);
	)
	
	for armCounter = 1 to listOfArms.count do (append qArray listOfArms[armCounter])
	
	armOutput = #(listOfArms,qArray)
	return armOutput
)

fn TakePics Obj anglevalue camdistance picname:objName objbody: objbody headBody: headBody fileNameForPic:ExportPath = (
	--Description: Takes photos of objects from any angle and distance. Two photos taken of each object; one where the object is face on, and another where it is rotated 45 degrees
	--Input: anglevalue (angle of camera above or below the ground), camdistance (distance of camera away from the object)
	--qqArray (entire object to be photographed), fileNameforPic (the folderpath of where the photo will be saved)
	--Outputs: will save a png or jpg of objects from 0 and 45 degree rotation respectively
	--Example Call: TakePics(45)(70) will take a photo 45 degrees above the ground and 70 units away
	include "Script_TakePics.ms"
)

fn Takevideo anglevalue camdistance picname:objName qqArray:qArray fileNameForPic:ExportPath = (
	--Description: Takes video of object rotating 360 degrees on its vertical axis. Video taken from specified angle above the ground and distance
	--Input: anglevalue (angle of camera above or below the ground), camdistance (distance of camera away from the object)
	--qqArray (entire object to be photographed), fileNameforPic (the folderpath of where the photo will be saved)
	--Outputs: saves video as mp4 (NOTE: FILE SIZES ARE QUITE LARGE)
	--Example Call: TakeVideo(0)(10) will take a photo 0 degrees above the ground and 10 units away
	include "Script_TakeVideo.ms"
)

fn MakeDefaultArms bendAngle objName assetPath:assetPath = (
	--Description: Creates and adds four arms to quaddle bodies. These are arms thead are either bent upwards or downwards
	--Input: bendAngle (the amount to which the arms are bent. Positive numbers bend downwards, Negative numbers bend upward), objName,
	--assetPath (the location of texture to be applied to arms. Default is a 70 70 70 greyscale)
	--Outputs: Creates arms and adds to qArray
	--Example Call: MakeDefaultArms(-30)(objName) will create 4 upward bending arms
	
	include "Script_DefaultArms.ms"
)

fn MakeAlternativeArms bendAngle startradius endradius objName numberOfArms genLeft assetPath:assetPath objVals: objVals isBeak: isBeak headBody: headBody = (
	--Description: Creates and adds four arms to quaddle bodies. The arms are cones which can have different diameters on each end
	--Input: bendAngle (the amount to which the arms are bent. Positive numbers bend downwards, Negative numbers bend upward), objName,
	--startradius (radius of base of cone embeded in object), endradius (end radius of cone sticking out of object)
	--assetPath (the location of texture to be applied to arms. Default is a 70 70 70 greyscale)
	--Outputs: Creates arms and adds to qArray
	--Example Call: MakeAlternateArms(0)(6)(0)(objName)(3) will create 3 straight pointed arms
	
	include "Script_AlternativeArms.ms"
)

fn MakeSphericalArms objName numberOfArms objbody body = (
	--Description: Creates and adds four arms to quaddle bodies. The arms are cones which can have different diameters on each end
	--Input: objName,
	--assetPath (the location of texture to be applied to arms. Default is a 70 70 70 greyscale)
	--Outputs: Creates arms and adds to qArray
	--Example Call: MakeSphericalArms(objName)(2) will create 2 spherical arms
	include "Script_SphericalArms.ms"
)

fn MakeCustomPyramidBody pattern pyramidpercentage = (
	--Description: Creates hybrid Oblong-Pyramid object
	--Input: pattern, pyramidpercentage (how "pyramidal" the object will be)
	--Outputs: Creates Pyramidal main body
	--Example Call: MakeCustomPyramidBody(pattern)(0.7) will create an object thead is 70% pyramidal, and 30% Oblong
	
	include "Script_CustomPyramidBody.ms"
)
	
fn MakeCustomAmalgamBody pattern pyramidpercentage oblongpercentage concavepercentage octahedronpercentage cubepercentage spherepercentage = (
	--Description: Creates hybrid object will be closer or farther away to some objects in its shape than others
	--Input: pattern & percentages for all the objects
	--Outputs: Creates amalgamated form of all object shapes
	--Example Call: MakeCustomAmalgamBody(pattern)(0.4)(0.2)(0.4)(0)(0)(0) will make an object 40% pyramidal, 20% Oblong, 40% concave, and 0% other shapes.
	--NOTE: Input values must sum up to one (e.g. 0.4 + 0.2 + 0.4 + 0 + 0 + 0 = 1)
	include "Script_CustomAmalgamBody.ms"
)

fn MakeOblongBody pattern ratio: ratio  = (
	--Description: Makes Oblong main body
	--Input: pattern
	--Example Call: MakeOblongBody() will create the object
	-- all the Make___Body functions follow a similar pattern
	include "Script_OblongBody.ms"
)

fn MakePyramidBody pattern ratio: ratio = (
	include "Script_PyramidalBody.ms"
)

fn MakeOctahedronBody pattern ratio: ratio = (
	include "Script_OctahedronBody.ms"
)	

fn MakeCubicBody pattern ratio: ratio = (
	include "Script_CubicBody.ms"
)

fn MakeDumbbellBody pattern ratio: ratio = (
	include "Script_DumbbellBody.ms"
)

fn MakeConvexBody pattern ratio: ratio = (
	include "Script_ConvexBody.ms"
)

fn MakePepperBody pattern ratio: ratio = (
	include "Script_PepperBody.ms"
)

fn MakeCompressedOblongBody pattern ratio: ratio = (
	include "Script_CompressedOblongBody.ms"
)

fn MakeSphereBody pattern ratio: ratio = (
	include "Script_SphereBody.ms"
)

fn MakeConcaveBody pattern ratio: ratio  = (
	include "Script_ConcaveBody.ms"
)