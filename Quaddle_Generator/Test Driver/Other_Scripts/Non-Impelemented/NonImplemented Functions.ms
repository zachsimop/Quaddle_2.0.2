-- DIMENSIONS IN QUADDLE 1.0 THAT HAVE NOT BEEN IMPLEMENTED IN QUADDLE 2.0	
-- Smoothess can be implemented at the ends of either making the Body or hat
	if findItem Dims "Smoothness" != 0 do (
			SmoothnessResult = ManipulateSurfaceTexture(headBody)(objVals[findItem Dims "Body (and/or Hat)"])
			objBody =s moothnessResult[1]
			--qArray = smoothnessResult[2]
			if (objVals[findItem Dims "Smoothness"] == "Hairy") then (
				Hair = headSmoothnessResult[3]
			)
		)
		
-- DELETES INTERIOR EMBEDOD PARTS OF ARMS IN OBJECTS (May be Useful if you want 3D transparent Objects for example)
	if (objHasArmAngle()) or (objHasArmAngle()) do (
-- 		--Removing interior polygons/faces/area of arms embeded within objects
		for armCount = 1 to listOfArms.count do(
-- 			--with createBooleanObject we subtract the object body from the arm
-- 			--3 means "copy, operand is a copy of original node" and 5 means using the objects original materials
-- 			--THIS PART IS CURRENTLY COMMENTED OUT DUE TO THE FACT THAT IT IS BUGGY FOR CERTAIN OBJECTS (Wrinkly Objects in Particular)
-- 			--resultantArm = boolObj.createBooleanObject listOfArms[armCount] objbody 3 5
-- 			--boolObj.setBoolOp resultantArm 3		
			)
	)
	
-- IF TRANSPARENCY IS IMPLEMENTED, HERE IS THE CODE TO PLACE IN THE MAKE OBJECT FUNCTION
if findItem Dims "Transparency" != 0 do
		qArray = ManipulateTransparency()

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
			blockyUVWMap = uvwmap()
			blockyUVWMap.maptype = 2 		--indicates spherical uvw mapping to be used
			addmodifier objbody blockyUVWMap
			blockyUVWMap.height = 70
			blockyUVWMap.width = 50
			blockyUVWMap.length = 50
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
		if (( objHasPattern() ) or ( objHasColour() )) do (
			objectHair.material = standardMaterial diffuseMap:(outMap) showInViewport:true;

			--applying UVW mapping
			hairMap = uvwmap()
			hairMap.maptype = 2 		--indicates spherical uvw mapping to be used
			hairMap.length = 50
			hairMap.width = 50
			hairMap.height = 50
			addmodifier objectHair hairMap
		)
		
		
		--now thead the hair has been converted to mesh we can delete the hair and fur modifier
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