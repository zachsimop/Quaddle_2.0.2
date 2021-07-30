clearListener()

--Need to add error messaging. This includes range permission for certain data (i.e. aspect ratio only has 3 values. If the user enters more than that, ObjAssoc
--write an error message. Other ones include syntax and others. 
testing = false

if testing then 
	loadInAssets()


fn loadInAssets = (
	--textures for main body
	Dims = #()
	Vals = #()

	if testing then (
		myPath = "C:\\Users\\zachs\\Documents\\Lab\\Quaddle_2.0.2\\Quaddle_Generator\\Test Driver\\Assets & Object Table\\Assets\\"
		objTable = openFile (myPath + "Object Table.txt")
		data = openFile (myPath + "Asset Data.txt")
		singleArmLoc = "Both"
	)
	
	goodSyntax = getUserData()				
	
	print "***DIMS***"
	print Dims
	print "***VALS***"
	print Vals
	local myData = spliceVals()
		
	global dimSet = myData[1]
	global valSet = myData[2]
	
	deleteArrayItems(myData)

	--if objects are set to be transparent, this number will determine how transparent the objects will be
	transparencyAmount = 25	
	objNames = #()
	
	--if you wish to make a custom object that is intermediate between shapes, you have to set one of the body dimensions as custom...
	--...and put in custom values here
	--Values must add up to 1!
	
	if testing then (
		close objTable
		close data
	)
	
)

fn getUserData
objTable: objTable data: data	Dims: Dims= (
	
	dimVal = 1
	counter = 1
	
	seek objTable 0
	seek data 0
	skipToString objTable "["
	
	while not (eof objTable) do (
		
		infoAsString = ""
		dimIncluded = true
		
		while (findString infoAsString "]" == undefined) do 
			infoAsString = infoAsString + readChar objTable
		
		
		infoAsString = substring infoAsString 1 (infoAsString.count-1)
		info = filterString infoAsString "," 
		
		maxVal = findMaxVal()
		
		for i = 1 to info.count do (
			
			newVal = info[i]
			newVal = trimLeft newVal
			newVal = trimRight newVal
			newVal = toLower newVal
			
			isGoodVal = checkVal(newVal)
			
			if isGoodVal then
				dimIncluded = addInformation(newVal)
			else	(
				
				close objTable
				close data
				return false
				
			)
			
		)
		
		if (dimIncluded) then (
			
			resetPosInFile()
			newDim = readDelimitedString data ":"
			newDim = trimLeft newDim
			append Dims newDim
			dimVal = dimVal + 1
			
		)
		
		skipToString objTable "["
		counter = counter + 1
		
	)
	
	modifyArmCount()
	
	return true
	
)

fn addInformation 
str dimVal: dimVal Vals: Vals Dims:Dims counter: counter = (

	resetPosInFile()
	
	if( doNotUseDim(str) ) then (
		return false
	)
	
	if ( useAllValsInDim(str) ) then (
		
		while not endOfLine() do (
			
			nextVal()
			addDataToArray()
			
		)
		
	)
	
	nextVal()
	
	if ( isRange(str) ) then (
		
		rangeVals = filterString str "-"
		
		startVal = rangeVals[1] as integer
		endVal = rangeVals[2] as integer
		
		gotoVal( startVal as string )
		
		for i = startVal to endVal do (
			
			addDataToArray()
			nextVal()
			
		)
		
	)
	
	if (str.count <= 2) then (
		
		gotoVal(str)
		addDataToArray()
		
	)
	
	return true
	
)

fn addDataToArray Vals: Vals = (
	
	if Vals[dimVal] == undefined then
		append Vals #()
	
	append Vals[dimVal] (readDelimitedString data "\"")
	
)

fn modifyArmCount = (
	
	if objHasArmCount() then
	if (findItem Vals[ getArmCountLoc() ] "1" != 0) then (

		if singleArmLoc == "Left" or singleArmLoc == "Both" then (
			insertItem "1L" (Vals[  getArmCountLoc()  ]) (findItem Vals[  getArmCountLoc()  ] "1")
		)
		if singleArmLoc == "Right" or singleArmLoc == "Both" then
			insertItem "1R"  (Vals[  getArmCountLoc()  ] ) (findItem Vals[ getArmCountLoc() ] "1")
		deleteItem (Vals[ getArmCountLoc() ]) (findItem Vals[ getArmCountLoc() ] "1")
		
	)

)

fn checkVal userVal maxVal: maxVal = (
	
	if doNotUseDim(userVal) or useAllValsinDim(userVal) or isRange(userVal) then (
		return true
	)
	
	if userVal as integer == undefined then (
		messageBox ("An invalid character was entered in the value: " + userVal)
		return false
	)
	
	userInt = userVal as integer
	if (userInt < 0) then (
		resetPosInFile()
		messagebox ("The value \"" + userVal + "\" is too small for the dimension \"" + (readDelimitedString data ":") + "\"")
		return false
	)
	
	if (userInt >= maxVal) then (
		messagebox ("The value \"" + userVal + "\" is too large for the dimension \"" + (readDelimitedString data ":") + "\"")
		return false
	)
	
	return true
)

fn checkForErrors 
Dims: Dims goodSyntax: goodSyntax = (
	
	if goodSyntax == false then 
		return false
	
	local mybool = true
	
	if objDoesNotHaveBody() then (
		
		messageBox "You must have a body"
		mybool = false
		return mybool
		
	)
	
	if objDoesNotHaveArmCount() and
	   ( objHasArmAngle() or objHasArmEnds() ) then (
		
		messageBox "You must have an Arm Count dimension to have have an Arm Angle or Arm End "
		mybool = false
		return mybool
		
	)
	
	if objDoesNotHaveBeak() and 
	  ( objHasBeakEnds() or objHasBeakAngle() ) then (
		
		messageBox "You must have a Head to have a Beak or Beak Angle"
		mybool = false
		return mybool
		
	)
	
	if objDoesNotHaveArmCount() and objHasArmAngle() then (
		
		messageBox "You must have an Arm to have an Arm Angle"
		mybool = false
		return mybool
		
	)
	
	if objDoesNotHaveBeak() and objHasBeakAngle() then (
		
		messageBox "You must have an Beak to have an Beak Angle"
		mybool = false
		return mybool
		
	)
	
	return mybool
	
)

fn spliceVals Vals: Vals Dims: Dims= (
	
	myDimArr = #()
	myValArr = #()
	
	if(( objHasPattern() or objHasColour()) and
		(objHasFractal()) and ( objHasIcon() )) then (

		local temp1Vals = deepCopy Vals
		local temp1Dims = deepCopy Dims
		deleteItem temp1Dims ( getFractalLoc() )
		deleteItem temp1Dims ( getIconLoc() )
		deleteItem temp1Vals ( getFractalLoc() )
		deleteItem temp1Vals ( getIconLoc() )
		append myDimArr temp1Dims
		append myValArr temp1Vals
		
		local temp2Vals = deepCopy Vals
		local temp2Dims = deepCopy Dims
		deleteItem temp2Vals ( getFractalLoc() )
		deleteItem temp2Dims ( getFractalLoc() )
		if( objHasPattern()) then
			deleteItem temp2Dims ( getPatternLoc() )
		if(objHasColour()) then
			deleteItem temp2Dims ( getColourLoc() ) 
		if( objHasPattern()) then
			deleteItem temp2Vals ( getPatternLoc() )
		if(objHasColour()) then
			deleteItem temp2Vals ( getColourLoc() ) 
		append myDimArr temp2Dims
		append myValArr temp2Vals
		
		local temp3Vals = deepCopy Vals
		local temp3Dims = deepCopy Dims
		deleteItem temp3Vals ( getIconLoc() )
		deleteItem temp3Dims ( getIconLoc() )
		if( objHasPattern()) then
			deleteItem temp3Dims ( getPatternLoc() )
		if( objHasPattern()) then
			deleteItem temp3Vals ( getPatternLoc() )
		if(objHasColour()) then
			deleteItem temp3Dims ( getColourLoc() ) 
		if(objHasColour()) then
			deleteItem temp3Vals ( getColourLoc() ) 
		
		append myValArr temp3Vals
		append myDimArr temp3Dims
		
		finished = #(myDimArr,myValArr)
		
		return finished
		
	)

	else if(( objHasPattern() or objHasColour()) and
			   (objHasFractal())) then (
		
		local temp1Vals = deepCopy Vals
		local temp1Dims = deepCopy Dims
		deleteItem temp1Dims ( getFractalLoc() )
		deleteItem temp1Vals ( getFractalLoc() )
		append myDimArr temp1Dims
		append myValArr temp1Vals

		local temp2Vals = deepCopy Vals
		local temp2Dims = deepCopy Dims
		if( objHasPattern()) then
			deleteItem temp2Dims ( getPatternLoc() )
		if( objHasPattern()) then
			deleteItem temp2Vals ( getPatternLoc() )
		if(objHasColour()) then
			deleteItem temp2Dims ( getColourLoc() )
		if(objHasColour()) then
			deleteItem temp2Vals ( getColourLoc() )
		append myDimArr temp2Dims
		append myValArr temp2Vals
		
		finished = #(myDimArr,myValArr)
		
		return finished
		
	)

	else if(( objHasPattern() or objHasColour()) and
			   ( objHasIcon() )) then (
		
		local temp1Vals = deepCopy Vals
		local temp1Dims = deepCopy Dims
		deleteItem temp1Dims ( getIconLoc() )
		deleteItem temp1Vals ( getIconLoc() )
		append myDimArr temp1Dims
		append myValArr temp1Vals
			
		local temp2Dims = deepCopy Vals
		local temp2Vals = deepCopy Vals
		if( objHasPattern()) then
			deleteItem temp2Dims ( getPatternLoc() )
		if( objHasPattern()) then
			deleteItem temp2Vals ( getPatternLoc() )
		if(objHasColour()) then
			deleteItem temp2Dims ( getColourLoc() )
		if(objHasColour()) then
			deleteItem temp2Vals ( getColourLoc() )
		append myDimArr temp2Dims
		append myValArr temp2Vals
		
		finished = #(myDimArr,myValArr)
		
		return finished
		
	)

	else if( (objHasFractal()) and ( objHasIcon() ) ) then (
		
		local temp1Vals = deepCopy Vals
		local temp1Dims = deepCopy Dims
		deleteItem temp1Dims ( getFractalLoc() )
		deleteItem temp1Vals ( getFractalLoc() )
		append myDimArr temp1Dims
		append myValArr temp1Vals
		
		local temp2Vals = deepCopy Vals
		local temp2Dims = deepCopy Dims
		deleteItem temp2Dims ( getIconLoc() )
		deleteItem temp2Vals ( getIconLoc() )
		append myDimArr temp2Dims
		append myValArr temp2Vals
		
		finished = #(myDimArr,myValArr)
		
		return finished
		
	)
	
	append myDimArr Dims
	append myValArr Vals

	finished = #(myDimArr,myValArr)
	
	return finished
	
)
