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
		greyColour = "100_100_100"
	
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

--INIT HELPER FUNCTIONS
--The Following 3 functions navigate asset data.txt

--nextVal allows you to traverse the values of a dimension via the ' " ' 
--	character. It is slightly deceptvive since in order to really go to the
--	next value, you must do it twice (since there are two quotations per value),
--	as you see in gotoVal(); however, this allows for better contol over 
--	traversing the program with less code.
fn nextVal = (
	
	skipToString data "\""
	
)

--Tells you when you've reached the end of a line, and respectively, a dimension
--	since one line represents a dimension. 
fn endOfLine =(
	
	return (readChar data) == ">"
	
)

-- Takes you to the respective value on the entered number in the dimension.
fn gotoVal s = (
	
	--parses double digit numbers
	loc = determineNum(s)
	
	if (loc != 0) then (
		
		for i = 1 to (loc*2) do 
			nextVal()
		
	)
	
)

--Checks if dimension will be used
fn doNotUseDim s = (
	
	return s == "none"
	
)

--Checks if every value of dimension will be used
fn useAllValsInDim s = (
	
	return s == "all"
	
)

--Checks if a range is specified
fn isRange s = (
	
	return findString s "-" != undefined 
	
)

--determines the value of a number
fn determineNum n = (
	
	--Determines if it is a double digit number
	if (n.count > 1 and n[2] as integer != undefined) then 
		returnNum = (substring n 1 2)
	else 
		returnNum = n[1]
	
	return returnNum as integer
	
)

--Puts the file curosor at the beginning of the line of whatever
--	dimension the program is at
fn resetPosInFile = (
	
	seek data 0
	for i = 1 to counter*2 do 
		skipToNextLine data

)

--Finds the max number of values in a given dimension
--	used for syntax error
fn findMaxVal = (
	
	resetPosInFile()
	local num = 0
	while not endOfLine() do (
		num = num + 1
		nextVal()
	)
	
	return num/2 
	
)

--Determines the number of mutually exclusive values in a given
--	generation
fn numOfME Dims: Dims = (
	
	local num = 0
	
	if objHasPattern() or objHasColour() then
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
	
	if Dims [loc] == "Pattern" or Dims[loc] == "Colour" then
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


--	"objHasDim" will tell you:
--	If Dims contain the specified dimension
--	This is useful for knowing what to generate.
--	Used well in makeQuaddle()
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

--	"objDoesNotHaveDim" will tell you:
--	If Dims does not contain the specified dimension
--	This is useful for knowing what to generate.
--	Used well in makeQuaddle()
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

--	"dimVal" will tell you:
--	The value of the dimension of the current object you
--	are generating. (gets the objVal values)
--	This is useful for passing to functions like makeBody( bodyVal() )
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

	if getPatternLoc() != 0 then
		return ( objVals [ getPatternLoc() ] )
	else return ("No Pattern")

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