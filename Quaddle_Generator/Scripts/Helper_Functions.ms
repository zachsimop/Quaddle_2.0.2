-- Attention-Circuits-Control L
--Laboratory (www.attention-circuits-control.org) --

--For more information on how Quaddles are generated and may be used:
-- Simopoulos, Z., Watson, MR., Voloh, B., Naghizadeh, M., Womelsdorf, T., (2021) “Quaddles: A multidimensional 3D object set with parametrically-controlled
-- and customizable features” Behav Res Methods.

--Website guide: http://accl.psy.vanderbilt.edu/resources/analysis-tools/3d-image-material/
--Brief instructions on how to use scripts: http://accl.psy.vanderbilt.edu/quaddlegenerator-brief-instructions/

--Scripts, objects and in depth manual available on github: https://github.com/att-circ-contrl/Quaddles-Gen

clearListener()

--Description: Loads in Paths given by Prefrences.txt and then other values specified in the text file
--Input: preferencePath
--Outputs: none
--Example Call: loadInPathsFilesAndPreferences()
fn loadInPathsFilesAndPreferences generatorPath: generatorPath = (
	
	pref = openFile (generatorPath + "User\\Preferences.txt")
	usePrefPath = loadPathSetting()
	
	if usePrefPath then (
		
		sysInfo.currentdir = getCurrentDirectory()
		assetPath = getAssetPath()
		ExportPath = getExportPath()
		objTable = openFile (generatorPath + "User\\Object Table.txt")
		data = openFile (assetPath + "Asset Data.txt")
		
		print assetPath
		print exportPath

		
	) else (
		
		sysInfo.currentdir = generatorPath + "Scripts\\"
		assetPath = generatorPath + "Assets\\"
		ExportPath = generatorPath + "User\\Images\\"
		makedir ExportPath
		objTable = openFile (generatorPath + "User\\Object Table.txt")
		data = openFile (assetPath + "Asset Data.txt")
		
	)
	
	customObjectPercentages = #()
	customObjecetPercentages = loadCustomPercentages()
	
	loadOtherPreferences()
	
)

fn loadPathSetting = (
	
	local usePath
	seek pref 0
	skipToString pref "Specify Your Own Paths:"
	tempString = readLine pref
	tempString = trimLeft tempString
	tempString = toLower tempString
	if(tempString == "on" or tempString == "yes") then
		usePath = true
	else
		usePath = false
	
	return usePath
	
)

fn loadOtherPreferences pref: pref = (
	
	global userWantsPics
	global userWantsFBX
	global greyColour
	global singleArmLoc
	global keepIandFVisible
	global applyAspectRatioToHead
	global PicAngle
	global applySmoothnessToHead
	global applySmoothnessToBody
	global printNotPossibleObjects
	
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
		greyColour = "7000000"
	else if (tempString == "dark") then  
		greyColour = "5000000"
	
	greyColour = "7000000"
	
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
	if(tempString == "on") then
		applyAspectRatioToHead = true
	else if (tempString == "off") then  
		applyAspectRatioToHead = false
	else 
		messageBox "Improper entry for \"Apply Apspect Ratio to Head:\""
		
	seek pref 0
	skipToString pref "Picture Angle:"
	tempString = readLine pref
	tempString = trimLeft tempString
	tempString = toLower tempString
	if (tempString as integer == undefined) then 
		messageBox "Improper entry for \"Picture Angle\""
	else
		PicAngle = tempString as integer
		
		
	seek pref 0
	skipToString pref "Apply Smoothness to Head:"
	tempString = readLine pref
	tempString = trimLeft tempString
	tempString = toLower tempString
	if(tempString == "on") then
		applySmoothnessToHead = true
	else if (tempString == "off") then  
		applySmoothnessToHead = false
	else 
		messageBox "Improper entry for \"Apply Smoothness to Head\""

	seek pref 0
	skipToString pref "Apply Smoothness to Body:"
	tempString = readLine pref
	tempString = trimLeft tempString
	tempString = toLower tempString
	if(tempString == "on") then
		applySmoothnessToBody = true
	else if (tempString == "off") then  
		applySmoothnessToBody = false
	else 
		messageBox "Improper entry for \"Apply Smoothness to Body\""
		
	seek pref 0
	skipToString pref "Print Objects that are Not Possible:"
	tempString = readLine pref
	tempString = trimLeft tempString
	tempString = toLower tempString
	if(tempString == "on") then (
		printNotPossibleObjects = true
		global notPossibleObjects = #()
	)
	else if (tempString == "off") then  
		printNotPossibleObjects = false
	else 
		messageBox "Improper entry for \"Print Objects that are were Not Possible\""
)

--Description: Loads in the constants and defaults of the program. 
--Input: none
--Outputs: none
--Example Call: loadInConstantsAndDefaults()
fn loadInConstantsAndDefaults = (
	
	global DEFAULT_HR = 2
	global PYRIMIDAL_HR = 1.5
	global CO_HR = 2.5
	global DEFAULT_ANGLES = EulerAngles 90 -90 0 as quat
	global CUBIC_ANGLES = EulerAngles 90 -135 0 as quat
	global SCALE_SIZE = 50
	global NAME_VAL = 0
	global ratio = 0
	global camDistance = 150
	global armScale = 1
	global allObjects = #()
	global numOfObjects = 0
	global isHair = false
	global isHead = false
	global noGen = "N/A"
	
)

fn printNongeneratedObjects = (
	
	if printNotPossibleObjects then (
		
		if notPossibleObjects.count != 1 and notPossibleObjects[1] == undefined then
			print "All Were Created"
		else (
			print "Objects that can not be created:"
			print notPossibleObjects
		)
		
	)
	
)

--Description: Loads in the custom percentages for makeAmalgamBody
--Input: none
--Outputs: none
--Example Call: loadCustomPercentages()
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

--Description: Builds objVal array by getting every 1st value of each
--					Dimension. This is then used in generateQuaddles.
--Input: Vals
--Outputs: new objVal array
--Example Call: initObjVals()
fn initObjVals Vals: Vals = (
	
	temp = #()
	for i = 1 to Vals.count do  
		append temp Vals[i][1]
	
	return temp
	
)

--Description: Exports 3d FBX model
--Input: obj, ExportPath, objName
--Outputs: none
--Example Call: ExportFBX()
fn ExportFBX
Obj: Obj ExportPath: ExportPath objName: objName =
(
	select Obj
	fileDir = (ExportPath + "fbxFiles\\")
	makeDir fileDir
	completeDir = fileDir + objName + ".fbx"
	--exporting textures along with the object
	FBXExporterSetParam "EmbedTextures" true
	exportFile completeDir  #noPrompt selectedOnly:true using:FBXEXP	
	
)

--Description: Takes 3D objects and smoothens.  Wrinkly objects are given TurboSmooth Smoothening
--Input: requires object values, and a 3D object body
--Outputs: Smoothens object body
fn SmoothenEdges 
objbody 
Dims:Dims objVals:objVals = 
(
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

fn loadFractalFiles startVal endVal = (
	
	tmp = #()
	j = 1
	for j = startVal to endVal do (
		
		filename = "F (" + (j as string) + ").png"
		append tmp filename
		
	)
	
	return tmp

)

--Determines the number of mutually exclusive values in a given
--	generation
fn numOfME Dims: Dims = (
	
	local num = 0
	
	if objHasBodyPattern() or objHasBodyMainColour() then
		num = num +1
	
	if objHasIcon() then
		num = num +1
	
	if objHasFractal() then 
		num = num +1
	
	return num
	
)

--Specifies if a dimension is mutually exculsive at a given location
--	Used primarily in createObjects()
fn isMutuallyExclusive loc Dims: Dims = (
	
	if Dims [loc] == "BPattern" or Dims[loc] == "BMain_Colour" or Dims[loc] == "BComp_Colour" then
		return true
	
	if Dims[loc] == "Icon" then
		return true
	
	if Dims[loc] == "Fractal" then 
		return true
	
	return false
	
)

--Resets Dims relative to the iter in createObjects()
--	This is because every mutually exclusive dimension 
--	behind the iter becomes "N/A".  These should not be 
--	reset because we do not want them in future quaddle
-- generates
fn resetDims iter Dims: Dims tempDims: tempDims = (
	
	for j = iter to tempDims.count do 
		Dims[j] = tempDims[j]

)

fn okToGenerate 
dimCount: dimCount objVals: objVals assetPath:assetPath objName: objName
allObjects: allObjects= (
	
	--At this point, there are certainis criter which were already checked
	--in the checkForErrors Function in Script_Initialization.ms
	--This function is called right before an object is generated
	--to see if it's pattern/colour combo exist. If it doesn't,
	--it will store the name into an object which saves the names of all the
	--objects that couldn't be generatred. Otherwise it gives QuaddleConstructor
	--the ok to generate the object (returns true)
	
	--ok if there is just a main body colour 
	if not objHasBodyCompColour() and not objHasHeadCompColour() then
		return true

	--verify the patterns are compatible
	local pcPath = assetPath + "Patterns and Colours\\"
	if objHasBodyCompColour() then (
		local BodyTexturePath= ( pcPath + "Pattern(" + BodyPatternVal() + ")+Colour(" + BodyMainColourVal() + "_" + BodyCompColourVal()+ ").png" )
		if (getFiles BodyTexturePath).count == 0 then (
		if printNotPossibleObjects then 
			append notPossibleObjects objName
		return false
		)
	)
	
	if objHasHeadCompColour() then (
		local HeadTexturePath= ( pcPath + "Pattern(" + HeadPatternVal() + ")+Colour(" + HeadMainColourVal() + "_" + HeadCompColourVal()+ ").png" )
		if (getFiles HeadTexturePath).count == 0 then (
			if printNotPossibleObjects then 
				append notPossibleObjects objName
			return false
		)
	)

	return true
	
)


fn nameObject objVals: objVals Dims: Dims = (
	
	local oName = objVals[1] 
	if objvals.count > 1 do (
		for iter = 2 to objVals.count do (
			if Dims[iter] != "N/A" then
				oName = oName + " + " + objVals[iter]
		)
	)
	
	return oName
	
)

--ZEN BOOLS USED A LOT IN THE PROGRAM
--The following are used to get specific information about
-- Dimensions and objVals.


--	"getDimLoc" will tell you:
--	The location of a dimesnion in Dims
--	This is useful for getting information from objVals
--	(the current object you are generating)
fn getBodyLoc Dims: Dims = (

	return (findItem Dims "Body")

)

fn getSmoothnessLoc Dims: Dims =(
	
	return ( findItem Dims "Smoothness" )
	
)

fn getAspectRatioLoc Dims: Dims = (

	return (findItem Dims "Aspect_Ratio")

)

fn getBodyMainColourLoc Dims: Dims = (

	return (findItem Dims "BMain_Colour")

)

fn getBodyCompColourLoc Dims: Dims = (

	return (findItem Dims "BComp_Colour")

)

fn getBodyPatternLoc Dims: Dims = (

	return (findItem Dims "BPattern")

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

fn getHeadMainColourLoc Dims: Dims = (

	return (findItem Dims "HMain_Colour")

)

fn getHeadCompColourLoc Dims: Dims = (

	return (findItem Dims "HComp_Colour")

)

fn getHeadPatternLoc Dims: Dims = (

	return (findItem Dims "HPattern")

)

fn getBeakLoc Dims: Dims = (

	return (findItem Dims "Beak")

)

fn getBeakAngleLoc Dims: Dims = (

	return (findItem Dims "Beak_Angle")

)

fn getBeakCountLoc Dims: Dims = (

	return (findItem Dims "Beak_Count")

)

fn getBeakEndsLoc Dims: Dims = (

	return (findItem Dims "Beak_Ends")

)


--	"objHasDim" will tell you:
--	If Dims contain the specified dimension
--	This is useful for knowing what to generate.
--	Used well in makeQuaddle()
fn objHasBody Dims: Dims  = (

	return (findItem Dims "Body" != 0)

)

fn objHasSmoothness Dims: Dims =(
	
	return ( findItem Dims "Smoothness" != 0 )
	
)

fn objHasAspectRatio Dims: Dims  = (

	return (findItem Dims "Aspect_Ratio" != 0)

)

fn objHasBodyMainColour Dims: Dims  = (

	return (findItem Dims "BMain_Colour" != 0)

)

fn objHasBodyCompColour Dims: Dims  = (

	return (findItem Dims "BComp_Colour" != 0)

)

fn objHasBodyPattern Dims: Dims  = (

	return (findItem Dims "BPattern" != 0)

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

fn objHasHeadMainColour Dims: Dims  = (

	return (findItem Dims "HMain_Colour" != 0)

)

fn objHasHeadCompColour Dims: Dims  = (

	return (findItem Dims "HComp_Colour" != 0)

)

fn objHasHeadPattern Dims: Dims  = (

	return (findItem Dims "HPattern" != 0)

)

fn objHasBeak Dims: Dims  = (

	return (findItem Dims "Beak" != 0)

)

fn objHasBeakAngle Dims: Dims  = (

	return (findItem Dims "Beak_Angle" != 0)

)

fn objHasBeakCount Dims: Dims  = (

	return (findItem Dims "Beak_Count" != 0)

)

fn objHasBeakEnds Dims: Dims  = (

	return (findItem Dims "Beak_Ends" != 0)

)

--	"dimVal" will tell you:
--	The value of the dimension of the current object you
--	are generating. (gets the objVal values)
--	This is useful for passing to functions like makeBody( bodyVal() )
fn bodyVal Dims: Dims = (

	return ( objVals [ getBodyLoc() ] )

)

fn smoothnessVal Dims: Dims =(
	
	return ( objVals [ getSmoothnessLoc() ] )
	
)

fn aspectRatioVal Dims: Dims = (

	return ( objVals [ getAspectRatioLoc() ] )

)

fn BodyMainColourVal Dims: Dims = (

	return ( objVals [ getBodyMainColourLoc() ] )

)

fn BodyCompColourVal Dims: Dims = (

	if getBodyCompColourLoc() != 0 then
		return ( objVals [ getBodyCompColourLoc() ] )
	return "None"

)

fn BodyPatternVal Dims: Dims = (

	if getBodyPatternLoc() != 0 then
		return ( objVals [ getBodyPatternLoc() ] )
	
	return ("Solid")

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

	if getHeadLoc() != 0 then
		return ( objVals [ getHeadLoc() ] )
	
	return "No Head"

)


fn HeadMainColourVal Dims: Dims = (

	if getHeadMainColourLoc() != 0 then
		return ( objVals [ getHeadMainColourLoc() ] )
	return "None"	
)

fn HeadCompColourVal Dims: Dims = (

	if getHeadCompColourLoc() != 0 then
		return ( objVals [ getHeadCompColourLoc() ] )
	return "None"	
)

fn HeadPatternVal Dims: Dims = (

	if getHeadPatternLoc() != 0 then
		return ( objVals [ getHeadPatternLoc() ] )
	
	return ("Solid")

)

fn beakVal Dims: Dims = (

	return ( objVals [ getBeakLoc() ] )

)

fn beakCountVal Dims: Dims = (

	return ( objVals [ getBeakCountLoc() ] as integer )

)

fn beakAngleVal Dims: Dims = (

	return ( objVals [ getBeakAngleLoc() ] )

)