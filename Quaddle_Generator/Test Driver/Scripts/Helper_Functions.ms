clearListener()

fn loadInPathsFilesAndPreferences preferencePath: preferencePath = (
	
	pref = openFile preferencePath
	sysInfo.currentdir = getCurrentDirectory()
	assetPath = getAssetPath()
	ExportPath = getExportPath()
	objTable = openFile (assetPath + "Object Table.txt")
	data = openFile (assetPath + "Asset Data.txt")
	
	customObjectPercentages = #()
	customObjecetPercentages = loadCustomPercentages()
	
	loadOtherPreferences()
	
)

fn loadInConstantsAndDefaults = (
	
	global DEFAULT_HR = 2
	global PYRIMIDAL_HR = 1.5
	global CO_HR = 2.5
	global DEFAULT_ANGLES = EulerAngles 90 -90 0 as quat
	global CUBIC_ANGLES = EulerAngles 90 -135 0 as quat
	global SCALE_SIZE = 50
	global ratio = 0
	global nameVal = 0
	global camDistance = 150
	
)

fn loadCustomPercentages = (
	
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

fn initObjVals newVal = (
	
	temp = #()
	for i = 1 to newVal.count do  
		append temp newVal[i][1]
	
	return temp
	
)

fn ExportObject
Obj: Obj ExportPath: ExportPath objName: objName =
(
	select Obj
	fileDir = (ExportPath + "fbxFiles\\")
	completeDir = fileDir + objName + ".fbx"
-- 	makedir completeDir
	--exporting textures along with the object
	FBXExporterSetParam "EmbedTextures" true
	exportFile completeDir  #noPrompt selectedOnly:true using:FBXEXP	
	
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

--PREFERNCE HELPERS ------------------------------------------------------------------
fn getCurrentDirectory pref: pref = (
	
	seek pref 0
	skipToString pref "Script Path"
	skipToString pref ":"
	tempString = readLine pref
	tempString = trimLeft tempString
	return tempString

	
)

fn getAssetPath pref: pref = (
	
	seek pref 0
	skipToString pref "Asset Path"
	skipToString pref ":"
	tempString = readline pref
	tempString = trimLeft tempString
	return tempString
	
)

fn getExportPath pref: pref = (
	
	seek pref 0
	skipToString pref "Export Path"
	skipToString pref ":"
	tempString = readline pref
	tempString = trimLeft tempString
	return tempString
	
)

fn loadOtherPreferences pref: pref = (
	
	global userWantsPics
	global userWantsFBX
	global greyColour
	global singleArmLoc
	global keepIandFVisible
	global applyAspectRatioToHead
	
	seek pref 0
	skipToString pref "Export PNGs:"
	tempString = readLine pref
	tempString = trimLeft tempString
	tempString = toLower tempString
	if(tempString == "on" or tempString == "yes") then
		userWantsPics = true
	else
		userWantsPics = false
	
	seek pref 0
	skipToString pref "Export fbxs:"
	tempString = readLine pref
	tempString = trimLeft tempString
	tempString = toLower tempString
	if(tempString == "on" or tempString == "yes") then
		userWantsFBX = true
	else
		userWantsFBX = false
		
	seek pref 0
	skipToString pref "Grey Colour:"
	tempString = readLine pref
	tempString = trimLeft tempString
	tempString = toLower tempString
	if(tempString == "light") then
		greyColour = "180_180_180"
	else if (tempString == "dark") then  
		greyColour = "70_70_70"
	
	seek pref 0
	skipToString pref "Location of Single Arm:"
	tempString = readLine pref
	tempString = trimLeft tempString
	tempString = toLower tempString
	if(tempString == "left") then
		singleArmLoc = "Left"
	else if (tempString == "right") then  
		singleArmLoc = "Right"
	else if (tempString == "both") then
		singleArmLoc = "Both"
		
	seek pref 0
	skipToString pref "Keep Icons and Fractals Visible:"
	tempString = readLine pref
	tempString = trimLeft tempString
	tempString = toLower tempString
	print tempString
	if(tempString == "on") then
		keepIandFVisible = true
	else if (tempString == "off") then  
		keepIandFVisible = false
	else 
		messageBox "Improper entry for \"Keep Icons and Fractals Visible\""
		
	seek pref 0
	skipToString pref "Apply Apspect Ratio to Head:"
	tempString = readLine pref
	tempString = trimLeft tempString
	tempString = toLower tempString
	print tempString
	if(tempString == "on") then
		applyAspectRatioToHead = true
	else if (tempString == "off") then  
		applyAspectRatioToHead = false
	else 
		messageBox "Improper entry for \"Apply Apspect Ratio to Head:\""
	
)


fn loadFractalFiles startVal endVal = (
	
	tmp = #()
	j = 1
	for j = startVal to endVal do (
		
		filename = "F (" + (j as string) + ").png"
		append tmp filename
		
	)
	
	return tmp

)

--ZEN BOOLS USED A LOT IN THE PROGRAM

fn getBodyLoc Dims: Dims = (

        return (findItem Dims "Body")

)

fn getAspectRatioLoc Dims: Dims = (

        return (findItem Dims "Aspect_Ratio")

)

fn getColourLoc Dims: Dims = (

        return (findItem Dims "Colour")

)

fn getPatternLoc Dims: Dims = (

        return (findItem Dims "Pattern")

)

fn getArmCountLoc Dims: Dims = (

        return (findItem Dims "Arm_Count")

)

fn getArmEndsLoc Dims: Dims = (

        return (findItem Dims "Arm_Ends")

)

fn getArmAngleLoc Dims: Dims = (

        return (findItem Dims "Arm_Angle")

)

fn getIconLoc Dims: Dims = (

        return (findItem Dims "Icon")

)

fn getFractalLoc Dims: Dims = (

        return (findItem Dims "Fractal")

)

fn getHeadLoc Dims: Dims = (

        return (findItem Dims "Head")

)

fn getBeakLoc Dims: Dims = (

        return (findItem Dims "Beak")

)

fn getBeakAngleLoc Dims: Dims = (

        return (findItem Dims "Beak_Angle")

)

fn getBeakEndsLoc Dims: Dims = (

        return (findItem Dims "Beak_Ends")

)

fn objHasBody Dims: Dims  = (

        return (findItem Dims "Body" != 0)

)

fn objHasAspectRatio Dims: Dims  = (

        return (findItem Dims "Aspect_Ratio" != 0)

)

fn objHasColour Dims: Dims  = (

        return (findItem Dims "Colour" != 0)

)

fn objHasPattern Dims: Dims  = (

        return (findItem Dims "Pattern" != 0)

)

fn objHasArmCount Dims: Dims  = (

        return (findItem Dims "Arm_Count" != 0)

)

fn objHasArmEnds Dims: Dims  = (

        return (findItem Dims "Arm_Ends" != 0)

)

fn objHasArmAngle Dims: Dims  = (

        return (findItem Dims "Arm_Angle" != 0)

)

fn objHasIcon Dims: Dims  = (

        return (findItem Dims "Icon" != 0)

)

fn objHasFractal Dims: Dims  = (

        return (findItem Dims "Fractal" != 0)

)

fn objHasHead Dims: Dims  = (

        return (findItem Dims "Head" != 0)

)

fn objHasBeak Dims: Dims  = (

        return (findItem Dims "Beak" != 0)

)

fn objHasBeakAngle Dims: Dims  = (

        return (findItem Dims "Beak_Angle" != 0)

)

fn objHasBeakEnds Dims: Dims  = (

        return (findItem Dims "Beak_Ends" != 0)

)


fn objDoesNotHaveBody Dims: Dims  = (

        return (findItem Dims "Body" == 0)

)

fn objDoesNotHaveAspect_Ratio Dims: Dims  = (

        return (findItem Dims "Aspect_Ratio" == 0)

)

fn objDoesNotHaveColour Dims: Dims  = (

        return (findItem Dims "Colour" == 0)

)

fn objDoesNotHavePattern Dims: Dims  = (

        return (findItem Dims "Pattern" == 0)

)

fn objDoesNotHaveArmCount Dims: Dims  = (

        return (findItem Dims "Arm_Count" == 0)

)

fn objDoesNotHaveArmEnds Dims: Dims  = (

        return (findItem Dims "Arm_Ends" == 0)

)

fn objDoesNotHaveArmAngle Dims: Dims  = (

        return (findItem Dims "Arm_Angle" == 0)

)

fn objDoesNotHaveIcon Dims: Dims  = (

        return (findItem Dims "Icon" == 0)

)

fn objDoesNotHaveFractal Dims: Dims  = (

        return (findItem Dims "Fractal" == 0)

)

fn objDoesNotHaveHead Dims: Dims  = (

        return (findItem Dims "Head" == 0)

)

fn objDoesNotHaveBeak Dims: Dims  = (

        return (findItem Dims "Beak" == 0)

)

fn objDoesNotHaveBeakAngle Dims: Dims  = (

        return (findItem Dims "Beak_Angle" == 0)

)

fn objDoesNotHaveBeakAngle Dims: Dims  = (

        return (findItem Dims "Beak_Angle" == 0)

)

fn bodyVal Dims: Dims = (

	return ( objVals [ getBodyLoc() ] )

)

fn aspectRatioVal Dims: Dims = (

	return ( objVals [ getAspectRatioLoc() ] )

)

fn colourVal Dims: Dims = (

	return ( objVals [ getColourLoc() ] )

)

fn patternVal Dims: Dims = (

	return ( objVals [ getPatternLoc() ] )

)

fn armCountVal Dims: Dims = (

	return ( objVals [ getArmCountLoc() ] )

)

fn armEndsVal Dims: Dims = (

	return ( objVals [ getArmEndsLoc() ] )

)

fn armAngleVal Dims: Dims = (

	return ( objVals [ getArmAngleLoc() ] )

)

fn iconVal Dims: Dims = (

	return ( objVals [ getIconLoc() ] )

)

fn fractalVal Dims: Dims = (

	return ( objVals [ getFractalLoc() ] )

)

fn headVal Dims: Dims = (

	return ( objVals [ getHeadLoc() ] )

)

fn beakVal Dims: Dims = (

	return ( objVals [ getBeakLoc() ] )

)

fn beakAngleVal Dims: Dims = (

	return ( objVals [ getBeakAngleLoc() ] )

)

fn deleteArrayItems arr = (
	
	for z = 1 to arr.count do
		deleteItem (arr) (1)
	
)

--INIT HELPER FUNCTIONS

fn nextVal = (
	
	skipToString data "\""
	
)

fn endOfLine =(
	
	return (readChar data) == ">"
	
)


fn doNotUseDim s = (
	
	return s == "none"
	
)

fn useAllValsInDim s = (
	
	return s == "all"
	
)

fn isRange s = (
	
	return findString s "-" != undefined 
	
)

fn gotoVal s = (
	
	loc = determineNum(s)
	
	if (loc != 0) then (
		
		for i = 1 to (loc*2) do 
			nextVal()
		
	)
	
)

fn determineNum n = (
	
	if (n.count > 1 and n[2] as integer != undefined) then 
		returnNum = (substring n 1 2)
	else 
		returnNum = n[1]
	
	return returnNum as integer
	
)

fn resetPosInFile = (
	
	seek data 0
	for i = 1 to counter*2 do 
		skipToNextLine data

)

fn findMaxVal = (
	
	resetPosInFile()
	local num = 0
	while not endOfLine() do (
		num = num + 1
		nextVal()
	)
	
	return num/2 
	
)


--generate object name
-- 	objName = Dims[1] + "(" + objVals[1] + ")"
-- 	if objvals.count > 1 do (
-- 		for dimCount = 2 to objvals.count do (
-- 			objName = objName + "+" + Dims[dimCount] + "(" + objVals[dimCount] + ")"
-- 		)
-- 	)
-- 	print objName
