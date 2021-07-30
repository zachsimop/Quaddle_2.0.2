-- Attention-Circuits-Control Laboratory (www.attention-circuits-control.org) --

--For more information on how Quaddles are generated and may be used:
--Watson, MR., Voloh, B., Naghizadeh, M., Womelsdorf, T., (2018) “Quaddles: A multidimensional 3D object set with parametrically-controlled
-- and customizable features” Behav Res Methods.

--Website guide: http://accl.psy.vanderbilt.edu/resources/analysis-tools/3d-image-material/
--Brief instructions on how to use scripts: http://accl.psy.vanderbilt.edu/quaddlegenerator-brief-instructions/

--Scripts, objects and in depth manual available on github: https://github.com/att-circ-contrl/Quaddles-Gen


--FUNCTIONS LIST

-- fn DefineAllObjects dimCount = (
-- 	--Description: This function will cycle through all possible combinations of features across dimensions depending on input into "objvals"
-- 	--Input: dimCount
-- 	--Outputs: allObjects (array of all possible objects)
-- 	--Example Call: DefineAllObjects(1)
-- 	
-- 	--print dimCount
-- 	for valCount = 1 to Vals[dimCount].count do(
-- 		objVals[dimCount] = Vals[dimCount][valCount]
-- 		--print objVals[dimCount]
-- 		if dimCount != Vals.count then
-- 		(
-- 		print "dimCount" + dimCount as string
-- 		DefineAllObjects(dimCount+1)
-- 		)
-- 		else if dimCount == Vals.Count then
-- 		(
-- 			i = i +1
-- 			--savePathFinal = saveImagePathe
-- 			temp = copy objVals #nomap
-- 			allObjects[i] = temp
-- 			--print ((i as string) +"  Dim1:" + objVals[1] + "___" + "Dim2:" + objVals[2]+ "___" + "Dim3:" + objVals[3] + "...")
-- 			--print (((allObjects.count) as string) + "  " + (allObjects as string))
-- 		)
-- 	)
-- )

fn TakePics anglevalue camdistance picname:objName qqArray:objStack  fileNameForPic:saveImagePath = (
	--Description: Takes photos of objects from any angle and distance. Two photos taken of each object; one where the object is face on, and another where it is rotated 45 degrees
	--Input: anglevalue (angle of camera above or below the ground), camdistance (distance of camera away from the object)
	--qqArray (entire object to be photographed), fileNameforPic (the folderpath of where the photo will be saved)
	--Outputs: will save a png or jpg of objects from 0 and 45 degree rotation respectively
	--Example Call: TakePics(45)(70) will take a photo 45 degrees above the ground and 70 units away
	include "Script_TakePics.ms"
	)

fn Takevideo anglevalue camdistance picname:objName qqArray:qArray fileNameForPic:saveImagePath = (
	--Description: Takes video of object rotating 360 degrees on its vertical axis. Video taken from specified angle above the ground and distance
	--Input: anglevalue (angle of camera above or below the ground), camdistance (distance of camera away from the object)
	--qqArray (entire object to be photographed), fileNameforPic (the folderpath of where the photo will be saved)
	--Outputs: saves video as mp4 (NOTE: FILE SIZES ARE QUITE LARGE)
	--Example Call: TakeVideo(0)(10) will take a photo 0 degrees above the ground and 10 units away
	include "Script_TakeVideo.ms"
	)

fn MakeDefaultArms bendAngle objName assetPath:assetPath = (
	--Description: Creates and adds four arms to quaddle bodies. These are arms that are either bent upwards or downwards
	--Input: bendAngle (the amount to which the arms are bent. Positive numbers bend downwards, Negative numbers bend upward), objName,
	--assetPath (the location of texture to be applied to arms. Default is a 70 70 70 greyscale)
	--Outputs: Creates arms and adds to qArray
	--Example Call: MakeDefaultArms(-30)(objName) will create 4 upward bending arms
	
	include "Script_DefaultArms.ms"
)

fn MakeAlternativeArms bendAngle startradius endradius objName numberOfArms assetPath:assetPath = (
	--Description: Creates and adds four arms to quaddle bodies. The arms are cones which can have different diameters on each end
	--Input: bendAngle (the amount to which the arms are bent. Positive numbers bend downwards, Negative numbers bend upward), objName,
	--startradius (radius of base of cone embeded in object), endradius (end radius of cone sticking out of object)
	--assetPath (the location of texture to be applied to arms. Default is a 70 70 70 greyscale)
	--Outputs: Creates arms and adds to qArray
	--Example Call: MakeAlternateArms(0)(6)(0)(objName)(3) will create 3 straight pointed arms
	
	include "Script_AlternativeArms.ms"
)

fn MakeSphericalArms objName numberOfArms objbody body assetPath:assetPath = (
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
	--Example Call: MakeCustomPyramidBody(pattern)(0.7) will create an object that is 70% pyramidal, and 30% Oblong
	
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

fn MakeOblongBody pattern  = (
	--Description: Makes Oblong main body
	--Input: pattern
	--Example Call: MakeOblongBody() will create the object
	-- all the Make___Body functions follow a similar pattern
	include "Script_OblongBody.ms"
)

fn MakePyramidBody pattern = (
	include "Script_PyramidalBody.ms"
)

fn MakeOctahedronBody pattern = (
	include "Script_OctahedronBody.ms"
)	

fn MakeCubicBody pattern = (
	include "Script_CubicBody.ms"
)

fn MakeDumbbellBody pattern = (
	include "Script_DumbbellBody.ms"
)

fn MakeConvexBody pattern = (
	include "Script_ConvexBody.ms"
)
fn MakePepperBody pattern = (
	include "Script_PepperBody.ms"
)
fn MakeCompressedOblongBody pattern = (
	include "Script_CompressedOblongBody.ms"
)

fn MakeSphereBody pattern = (
	include "Script_SphereBody.ms"
)

fn MakeConcaveBody pattern  = (
	include "Script_ConcaveBody.ms"
)

fn MakeBody 
body 
objName:objName pattern:pattern percentages: percentages 
Dims: Dims Vals:Vals qArray:qArray = 
(
	--Description: Creates main body of objects. Accesses appropriate scripts for specific body
	--Input: requires object values, and object percentages for custom "amalgam" bodies
	--Outputs: Creates main body
	--Example Call: MakeBodies("Cubic") will make the cubic body
		
	
	if (findItem Dims "Pattern" != 0) then 
		(
			local pattern = objVals[findItem Dims "Pattern"]
		)
	else
		(
			local pattern = "None"
		)
		
	if (body == "Oblong") then(
		bodyResult = MakeOblongBody(pattern)
		controlPoint = bodyResult[1]
		objbody = bodyResult[2]
		polygonner = bodyResult[3]
		)
	else if (body == "Pyramidal") then(
		bodyResult = MakeCustomPyramidBody(pattern)(0.8)
		controlPoint = bodyResult[1]
		objbody = bodyResult[2]
		polygonner = bodyResult[3]
		)
	else if (body == "Concave") then(
		bodyResult = MakeConcaveBody(pattern)
		controlPoint = bodyResult[1]
		objbody = bodyResult[2]
		polygonner = bodyResult[3]
		)
	else if (body == "Octahedron") then(
		bodyResult = MakeOctahedronBody(pattern)
		controlPoint = bodyResult[1]
		objbody = bodyResult[2]
		polygonner = bodyResult[3]
		)
	else if (body == "Cubic") then(
		bodyResult = MakeCubicBody(pattern)
		controlPoint = bodyResult[1]
		objbody = bodyResult[2]
		polygonner = bodyResult[3]
		)
	else if (body == "Dumbbell") then(
		bodyResult = MakeDumbbellBody(pattern)
		controlPoint = bodyResult[1]
		secondControlPoint = bodyResult[2]
		objbody = bodyResult[3]
		reflector = bodyResult[4]
		polygonner = bodyResult[5]
		)
	else if (body == "Convex") then(
		bodyResult = MakeConvexBody(pattern)
		controlPoint = bodyResult[1]
		secondControlPoint = bodyResult[2]
		objbody = bodyResult[3]
		polygonner = bodyResult[4]
		)
	else if (body == "Pepper") then(
		bodyResult = MakePepperBody(pattern)
		controlPoint = bodyResult[1]
		secondControlPoint = bodyResult[2]
		objbody = bodyResult[3]
		polygonner = bodyResult[4]
		)
		--compressedOblongOutput = #(controlPoint,objbody,squisher,polygonner2)
	else if (body == "Compressed_Oblong") then(
		bodyResult = MakeCompressedOblongBody(pattern)
		controlPoint = bodyResult[1]
		objbody = bodyResult[2]
		squisher = bodyResult[3]
		polygonner = bodyResult[4]
		)	
	else if (body == "Spherical") then(
		bodyResult = MakeSphereBody(pattern)
		controlPoint = bodyResult[1]
		objbody = bodyResult[2]
		polygonner = bodyResult[3]
		)
	else if (body == "Custom") then(
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

fn SmoothenEdges 
objbody 
Dims:Dims objVals:objVals = 
(
	--Description: Takes 3D objects and smoothens.  Wrinkly objects are given TurboSmooth Smoothening
	--Input: requires object values, and a 3D object body
	--Outputs: Smoothens object body
	if (findItem Dims "Smoothness" != 0) and (objVals[findItem Dims "Smoothness"] == "Wrinkled") then (
		polygonner = TurboSmooth()
		polygonner.iterations = 2
	)
	else (
				polygonner = TesselLate()
			)
	addModifier objbody(polygonner)
)


fn ApplyTexture 
objbody 
assetPath:assetPath Dims:Dims Vals:Vals objvals:objvals =
(
	--Description: Applies texture to main body of object
	--Input: objbody (main object body), assetPath(texture and folder path to be applied), Dims(object dimensions), Vals, objvals(
	--Example Call: ApplyTexture(objbody)("C://Person//Documents//Patterns//Pattern(Diamond)+Colour(Blue)") will apply the blue diamond pattern to the "objbody" object
	
	if (findItem Dims "Pattern_Inversion" != 0) then (
		if  (objVals[findItem Dims "Pattern_Inversion"] == "Inverted") then (
			invertText = "_inv"
		)
		else (invertText = "")
	)
	else (invertText = "")
	
	
	if ((findItem Dims "Pattern" != 0) and (findItem Dims "Colour" != 0) ) then 
	(
		--texture for main body
		texturePath= assetPath + "Pattern(" + objVals[findItem Dims "Pattern"] + ")+Colour(" + objVals[findItem Dims "Colour"] + ")" + invertText + ".png"
		pattern = objVals[findItem Dims "Pattern"]
		colour = objVals[findItem Dims "Colour"]
	)
	else if (findItem Dims "Pattern" == 0) then (
		texturePath= assetPath + "Colour(" + objVals[findItem Dims "Colour"] + ")" + invertText + ".png"
		colour = objVals[findItem Dims "Colour"]
	)
	else if (findItem Dims "Colour" == 0) then (
		texturePath= assetPath + "Pattern(" + objVals[findItem Dims "Pattern"] + ")" + invertText + ".png"
		pattern = objVals[findItem Dims "Pattern"]
	)
	
	
	if (findItem Dims "Body" != 0) then (
		body = objVals[findItem Dims "Body"]
	)
	
		
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
Dims: Dims objVals:objVals objName:objName objbody:objbody = 
(
	--Description: Makes Arms
	--Input: arms(specific kind of arms to be made), objName (the name of the object)
	--Outputs: Creates arms
	--Example Call: MakeArms("Bent_Up")("Body(Oblong)+Arms(Bent_Up)") will add arms to the object that are bent upwards
	
	--if(objName != "Pedastal") do (body = objVals[findItem objVals "Body"])
	
	if ( isQuaddle() ) then (
	
		if findItem Dims "Arm_Angle" != 0 then (
			arms = objVals[findItem Dims "Arm_Angle"]
		)
		else (
			arms = "Straight"
		)
		
		if findItem Dims "Arm_Ends" != 0 then (
			armEnds = objVals[findItem Dims "Arm_Ends"]
		)
		else (
			armEnds = "Flat"
		)
		
	)
	
	if ( isPedastal() ) then (
		
		if findItem Dims "Arm_Angle" != 0 then (
			arms = objVals[findItem Dims "Arm_Angle"]
		)
		else (
			arms = "Straight"
		)
		
		if findItem Dims "Arm_Ends" != 0 then (
			armEnds = objVals[findItem Dims "Arm_Ends"]
		)
		else (
			armEnds = "Flat"
		)

	)

	
	--the number of arms on the object is specificied by "ArmCount". If it's not present then the number of arms is set to 4
	if findItem objVals "ArmCount" != 0 then (numberOfArms = objVals[findItem objVals "ArmCount"] as integer) else (numberOfArms = 4)
	
	--if Arms are spherical, we can right away make them, if not we have to specificy some other values
	if (arms == "Spherical") or (armEnds == "Spherical") then (listOfArms = MakeSphericalArms(objName)(numberOfArms)(objbody)(body))
	else (
		if (arms == "Bent_Down") then (bendAngle = 45)
		else if (arms == "Bent_Up") then (bendAngle = -45)
		else if (arms == "Straight") then (bendAngle = 0)
		else (bendAngle = 0);
		
		if (armEnds == "Blunt") then (
			--startradius = 5; endradius = 1;
			endradius = 2 ; startradius = 6;
		)
		else if (armEnds == "Pointed") then (
			endradius = 0; startradius = 6;
		)
		else if (armEnds == "Flared") then (
			--endradius = 5; startradius = 2;
			endradius = 5; startradius = 2;
		)
		else if (armEnds == "Flat") then (
			--endradius = 5; startradius = 2;
			endradius = 4; startradius = 4;
		)
		else (endradius = 4; startradius = 4;)
		

		--MakeAlternativeArms is the actual function that makes the arms
		listOfArms = MakeAlternativeArms(bendAngle)(startradius)(endradius)(objName)(numberOfArms);
	)
	
	for armCounter = 1 to listOfArms.count do (append qArray listOfArms[armCounter])
	
	
	
	armOutput = #(listOfArms,qArray)
	return armOutput
)
	
fn ManipulateSurfaceTexture 
objbody body 
smoothness:objVals[findItem Dims "Smoothness"]  assetPath:assetPath 
qArray:qArray Vals:Vals Dims:Dims outMap:outMap objvals:objVals =
(
	--Description: Manipulates surface topology of the main body of the object to add variations
	--Input: smoothness, objbody,assetPath (uses a picture of some black and white noise to add wrinkles to topology for wrinkled texture), qArray, Vals, & dimensions
	--Example Call: ManipulateSurfaceTexture("Wrinkled")(objbody)(assetPath) will wrinkle up the surface of the object
	
	 if body == unsupplied then (body = objVals[findItem Dims "Body"])

	 
	--Wrinkled texture
	if (smoothness=="Wrinkled") then (	
		wrinkler = displace()
		wrinkler.strength = 6.5 --9
		wrinkler.decay = 1
		noisePath = assetPath + "noise2d" + ".png"
		wrinkler.bitmap =  openBitMap noisePath
		wrinkler.maptype = 2 --spherical mapping
		wrinkler.length = 100
		wrinkler.width = 100
		wrinkler.height = 100
		addmodifier objbody wrinkler
		convertToPoly(objbody)
	)
	--OTHER TEXTURES
	

	--Geodesic texture
	--outputs manipulatePolys
	if (smoothness=="Geodesic") or (smoothness=="Blocky") then (
		--MANIPULATING OBJECT SURFACE
		manipulatePolys = EditPolyMod()
		manipulateTopBottomPolys = EditPolyMod()
		--addmodifier objbody manipulatePolys
		
		convertToPoly(objbody)
		polyop.setFaceSelection objbody #all
		allFaces = polyop.getFaceSelection objbody
		
		if (body =="Pepper") or (body=="Convex") or (body=="Octahedron") then (
			topAndBottomFaces =  #{1..440, 561..640, 761..840, 961..1040, 1161..2080, 2321..2480, 2721..2880, 3121..3280, 3521..3600}
			middleFaces = allFaces - topAndBottomFaces
			
			max modify mode
			select objbody
			--subObjectLevel = 4
			
			--top and bottom Polys
			modPanel.addModToSelection(manipulateTopBottomPolys)
			manipulateTopBottomPolys.SetSelection #Face topAndBottomFaces
			--all the other polys
			modPanel.addModToSelection(manipulatePolys)
			manipulatePolys.SetSelection #Face middleFaces
			
			manipulateTopBottomPolys.SetOperation#Inset
			manipulateTopBottomPolys.insetType = 1
			manipulateTopBottomPolys.insetAmount = 0.1 --0.02
			manipulateTopBottomPolys.SetOperation#Bevel
			manipulateTopBottomPolys.bevelType = 2 --adjusting bevel by polygons
			manipulateTopBottomPolys.bevelHeight =  -0.1 -- -0.2
			manipulateTopBottomPolys.bevelOutline = -0.04 -- -0.005
			

			--middle faces manipulation
			manipulatePolys.SetOperation#Inset
			manipulatePolys.insetType = 1
			manipulatePolys.insetAmount = 0.15 --0.02
			manipulatePolys.SetOperation#Bevel
			
			manipulatePolys.bevelType = 2 --adjusting bevel by polygons
			manipulatePolys.bevelHeight = -1.2 -- -0.2
			manipulatePolys.bevelOutline = -0.2 -- -0.005
			
		)
		else (
			--setFaceSelection objbody selectedFaces
			max modify mode
			select objbody
			--subObjectLevel = 4
			modPanel.addModToSelection(manipulatePolys)
			manipulatePolys.SetSelection #Face allFaces
			manipulatePolys.SetOperation#Inset
			manipulatePolys.insetType = 1
			manipulatePolys.insetAmount = 0.15
			manipulatePolys.SetOperation#Bevel
			
			manipulatePolys.bevelType = 2 --adjusting bevel by polygons
			manipulatePolys.bevelHeight = -1.2 
			manipulatePolys.bevelOutline = -0.2 
		)
		
		if (smoothness=="Blocky") then (
			--making blocky shapes
			reducePolygons = ProOptimizer()
			addmodifier objbody reducePolygons
			--depending on the body of the object, we reduce the polygon count by different amounts
			if (body=="Pepper") then(
				percentReduction = 2.6)
			else if (body == "Pyramidal") then (
				percentReduction = 2.1)
			else (
				percentReduction = 1.9
			)
			reducePolygons.VertexPercent = percentReduction
			reducePolygons.KeepUV = true 
			reducePolygons.Calculate = true
			
			max create mode
			select objbody
			subObjectLevel = 0
			
			--adding another UVW map because decreasing polygon count can interfere with pattern on objects
-- 			blockyUVWMap = uvwmap()
-- 			blockyUVWMap.maptype = 2 		--indicates spherical uvw mapping to be used
-- 			addmodifier objbody blockyUVWMap
-- 			blockyUVWMap.height = 70
-- 			blockyUVWMap.width = 50
-- 			blockyUVWMap.length = 50
			ApplyTexture(objbody)
			)
		
	)
	
	
	--outputs manipulatePolys, smoothener, faceExtruder, and reducePolygons
	if (smoothness=="Inward_Protrusions") or (smoothness=="Outward_Protrusions")  then(
		
		--MANIPULATING OBJECT SURFACE
		manipulatePolys = EditPolyMod()
		--addmodifier objbody manipulatePolys
		
		--deleteModifier objbody polygonner2
		--deleting increased polygon count
		for theModifier in objbody.modifiers where classOf theModifier == Tessellate do
			(
				deleteModifier objbody theModifier
			)
		for theModifier in objbody.modifiers where classOf theModifier == turboSmooth do
			(
				deleteModifier objbody theModifier
			)
		
		convertToPoly(objbody)
		polyop.setFaceSelection objbody #all
		selectedFaces = polyop.getFaceSelection objbody
		
		--setFaceSelection objbody selectedFaces
		max modify mode
		select objbody
		subObjectLevel = 4
		modPanel.addModToSelection(manipulatePolys)

		manipulatePolys.SetOperation#Inset
		manipulatePolys.insetType = 1
		manipulatePolys.insetAmount = 0.15 --0.2
		
		manipulatePolys.SetOperation#Bevel
		manipulatePolys.bevelType = 2 --adjusting bevel by polygons
		manipulatePolys.bevelHeight = 0.15
		manipulatePolys.bevelOutline = -0.015
		
		smoothener = meshSmooth()
		addmodifier objbody smoothener
		
		faceExtruder = face_extrude()
		if (smoothness=="Inward_Protrusions") then(
			faceExtruder.amount = -1.5 --determines if innie or outtie
		)
		else if (smoothness=="Outward_Protrusions") then (
			faceExtruder.amount = 1.5 --determines if innie or outtie
		)
		faceExtruder.scale = 2.0
		addmodifier objbody faceExtruder

		--making polygons on surface simpler
		reducePolygons = ProOptimizer()
		addmodifier objbody reducePolygons
		reducePolygons.VertexPercent = 30
		reducePolygons.KeepUV = true 
		reducePolygons.Calculate = true
		
		max create mode
		select objbody
		subObjectLevel = 0
		
	)
	
	--Adding Hair to object if object is specificied to be hairy
	--outputs objectHair and hairMap
	if (smoothness=="Hairy") then(
		
		addingHair = HairMod()
		addmodifier objbody addingHair
		
		addingHair.HairCount = 6000
		addingHair.HairSegments = 3
		addingHair.HairPasses = 1
		
		addingHair.HairCutLength = 60 --70
		addingHair.HairRandScale = 100
		
		addingHair.HairRootThickness = 7
		addingHair.HairTipThickness = 0.5
		
		addingHair.HairInterpolateGuides = true
		
		addingHair.Clumps = 35
		addingHair.ClumpsStren = 0.45 --0.45
		
		--Converting hair into mesh
		objectHair = addingHair.ConvertToMesh instance:objbody
		objectHair.name = "body" + "_hair"
		
		--applying object material to object, if it has one
		if ((findItem Dims "Pattern" != 0) or (findItem Dims "Colour" != 0)) do (
			objectHair.material = standardMaterial diffuseMap:(outMap) showInViewport:true;

			--applying UVW mapping
			hairMap = uvwmap()
			hairMap.maptype = 2 		--indicates spherical uvw mapping to be used
			hairMap.length = 50
			hairMap.width = 50
			hairMap.height = 50
			addmodifier objectHair hairMap
		)
		
		
		--now that the hair has been converted to mesh we can delete the hair and fur modifier
		deleteModifier objbody addingHair
		
		append qArray objectHair
		
	)
	
	if (smoothness=="Hairy") then(
		bodyOutput = #(objbody,qArray,objectHair)
		return bodyOutput	
	)
	else 
	(
		bodyOutput = #(objbody,qArray)
		return bodyOutput	
	)
)

fn ManipulateTransparency 
transparency:objVals[findItem Dims "Transparency"] objbody:objbody 
qArray:qArray listOfArms:listOfArms transparencyAmount:transparencyAmount = 
(
	--Description: Manipulates transparency of object components
	--Input: transparency, objbody, qArray
	--Example Call: ManipulateTransparency("Transparent")(objbody)(qArray) will take your object and make it transparent
	
	for qArrayCount = 1 to qArray.count do 
	(
		if qArray[qArrayCount] != undefined then
		(
			if (transparency== "Transparent") then(
				qArray[qArrayCount].material.opacity = transparencyAmount --25%transparency applied
				)
		)
	)
	
	return qArray
)


--MAIN FUNCTION FOR MAKING OBJECTS--
fn MakeObject 
Dims:Dims Vals:Vals objVals:objVals
saveImagePath:saveImagePath assetPath:assetPath  percentages: percentages
transparencyAmount:transparencyAmount = 
(
	--Description: Main function for making and saving objects
	--Input: pretty much all variables from the MainScript script
	--Example Call: MakeObject() will create a given object defined by its features in "objvals"


--Ensure Dimensions are labeled correctly
if findItem Dims "Color" != 0 do
(
	Dims[findItem Dims "Color"] = "Colour"
)

if findItem Dims "Arms" != 0 do
(
	Dims[findItem Dims "Arms"] = "Arm_Angle"
)
		

	--generate object name
-- 	objName = Dims[1] + "(" + objVals[1] + ")"
-- 	if objvals.count > 1 do (
-- 		for dimCount = 2 to objvals.count do (
-- 			objName = objName + "+" + Dims[dimCount] + "(" + objVals[dimCount] + ")"
-- 		)
-- 	)
-- 	print objName
	
	--qArray is simply an array of all the components which will comprise of the quaddle
	qArray = #()
	

		
--BODY GENERATION
	if findItem Dims "Body" != 0 do
		(
			bodyResult = MakeBody(objVals[findItem Dims "Body"])
			objbody = bodyResult[1]
			polygonner = bodyResult[2]
			qArray = bodyResult[3]
			if findItem Dims "Hat" !=0 do 
			(
				hatBody.pos = [0,0,(objbody.max[3])]
				if findItem Dims "Smoothness" != 0 do (
					if (objVals[findItem Dims "Smoothness"] == "Hairy") then (
						hatHair.pos = [0,0,(objbody.max[3])]
					)
				)
			)
			SmoothenEdges(objbody)
		)
		
	if ((findItem Dims "Pattern" != 0) or (findItem Dims "Colour" != 0)) do
		(
			textureResult = ApplyTexture(objbody)
			assetPath = textureResult[1]
			map = textureResult[2]
			objbody = textureResult[3]
			outMap = textureResult[4]
		)
		
	if(findItem Dims "Icon" != 0) do 
		(
			iconPath = assetPath + "Icons\\" + objVals[findItem Dims "Icon"]
			mat = Bitmaptexture filename:(iconPath)
			objbody.material = standardMaterial diffuseMap:(mat)
			myMap = uvwmap() 
			addModifier objbody myMap
			myMap.gizmo SubAnim
			myMap.gizmo.rotate Quat (quat -1 -1 0 0)
		)
		
	if findItem Dims "Smoothness" != 0 do
		(
			smoothnessResult = ManipulateSurfaceTexture(objbody)(objVals[findItem Dims "Body"])
			objbody = smoothnessResult[1]
			qArray = smoothnessResult[2]
		)

		

--HAT GENERATION
-- 	if findItem Dims "Hat" !=0 do
-- 		(
-- 			hatResult = MakeBody(objVals[findItem Dims "Hat"])
-- 			hatBody = hatResult[1]
-- 			hatPolygonner = hatResult[2]
-- 			--append qArray hatBody[3]
-- 	 		if ((findItem Dims "Pattern" != 0) or (findItem Dims "Colour" != 0)) do
-- 				(
-- 					hatTextureResult = ApplyTexture(hatBody)
-- 					assetPath = hatTextureResult[1]
-- 					hatMap = hatTextureResult[2]
-- 					hatBody = hatTextureResult[3]
-- 					hatoutMap = hatTextureResult[4]
-- 				)
-- 			scale hatBody [0.45,0.45,0.45]
-- 			--hatBody.pos = [0,0,23]
-- 			SmoothenEdges(hatBody)
-- 			if findItem Dims "Smoothness" != 0 do
-- 				(
-- 					hatSmoothnessResult = ManipulateSurfaceTexture(hatBody)(objVals[findItem Dims "Hat"])
-- 					hatBody = hatSmoothnessResult[1]
-- 					--qArray = smoothnessResult[2]
-- 					if (objVals[findItem Dims "Smoothness"] == "Hairy") then (
-- 						hatHair = hatSmoothnessResult[3]
-- 					)
-- 				)
-- 		)
		
--ARM GENERATION
	if (findItem Dims "Arm_Angle" != 0)  or (findItem Dims "Arm_Ends" != 0) do
		(
			--if ArmCount dimension exist, and it is not set to zero, then arms are made OR if ArmCount dimension does not exist but other arm dimensions do
			if ((findItem Dims "ArmCount" != 0) and (objVals[findItem Dims "ArmCount"] != "0")) or (findItem Dims "ArmCount" == 0) do
			(
				armResult = MakeArms()
				listOfArms = armResult[1] 
				qArray = armResult[2]
			)
		)
		
	if findItem Dims "Transparency" != 0 do
		(
			qArray = ManipulateTransparency()
		)
		
		--DELETES INTERIOR EMBEDOD PARTS OF ARMS IN OBJECTS (May be Useful if you want 3D transparent Objects for example)
	if (findItem Dims "Arm_Angle" != 0) or (findItem Dims "Arm_Ends" != 0) do (
		--Removing interior polygons/faces/area of arms embeded within objects
		for armCount = 1 to listOfArms.count do(
			--with createBooleanObject we subtract the object body from the arm
			--3 means "copy, operand is a copy of original node" and 5 means using the objects original materials
			--THIS PART IS CURRENTLY COMMENTED OUT DUE TO THE FACT THAT IT IS BUGGY FOR CERTAIN OBJECTS (Wrinkly Objects in Particular)
			--resultantArm = boolObj.createBooleanObject listOfArms[armCount] objbody 3 5
			--boolObj.setBoolOp resultantArm 3		
			)
	)
		
		
	return qArray
-- 	-- once all parts of the objects are grouped together in a single array, we can combine them into
-- 	--one as a sigle object and name it accordingly
-- 	group (qArray as array) name:objName

)

fn getQuaddleInfo
objVals: objVals objTable: objTable Vals: Vals objDetails: objDetails= (
		
		objDetails = readLine objTable
	
		for dimCount = 1 to ((objDetails.count + 1)/2) do (
			objVals[dimCount] = Vals[dimCount][objDetails[((2*dimCount)-1)] as integer + 1]
			print objVals[dimCount]
		)

			

)

--HELPER METHODS

fn ExportObject
objStack: objStack saveImagePath: saveImagePath =
(

	for i = 1 to objStack.count do
		selectmore objStack[i]
	
	fileDir = (saveImagePath + "fbxFiles\\")
	fileName = (objName + ".fbx")
	makedir fileDir
	--exporting textures along with the object
	FBXExporterSetParam "EmbedTextures" true
	exportFile fileName  #noPrompt selectedOnly:true using:FBXEXP	
	
)
	
fn loadCustomPercentages = 
(
	
	percentages = #()
	
	pyramidpercentage = 0; 
	append percentages pyramidpercentage;
		
	oblongpercentage = 0.2;
	append percentages oblongpercentage;
		
	concavepercentage = 0.4;
	append percentages oblongpercentage;
		
	octahedronpercentage = 0; 
	append percentages octahedronpercentage;
		
	cubepercentage = 0.2; 
	append percentages cubepercentage;
	
	spherepercentage= 0.2;
	append percentages spherepercentage;
	
	return percentages
	
)
