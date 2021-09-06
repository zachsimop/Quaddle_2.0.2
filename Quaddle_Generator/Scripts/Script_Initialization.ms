-- Attention-Circuits-Control L
--Laboratory (www.attention-circuits-control.org) --

--For more information on how Quaddles are generated and may be used:
--Watson, MR., Voloh, B., Naghizadeh, M., Womelsdorf, T., (2018) “Quaddles: A multidimensional 3D object set with parametrically-controlled
-- and customizable features” Behav Res Methods.

--Website guide: http://accl.psy.vanderbilt.edu/resources/analysis-tools/3d-image-material/
--Brief instructions on how to use scripts: http://accl.psy.vanderbilt.edu/quaddlegenerator-brief-instructions/

--Scripts, objects and in depth manual available on github: https://github.com/att-circ-contrl/Quaddles-Gen

--This program is essentially a stand alone program; however, it functions to feed the main script the 
-- Dimensions and Values the user enters. The navigating functions (found in "Helper_Functions.ms") help traverse
-- Asset_Data.txt and are used in addInformation().
clearListener()

--change to true if you want to debug this file
testing = false

if testing then 
	loadInAssets()


fn loadInAssets = (
	
	Dims = #()
	Vals = #()

	--Hardcoded paths for debugging
	if testing then (
		myPath = "C:\\Users\\zachs\\Documents\\Lab\\Quaddle_2.0.2\\Quaddle_Generator\\"
		objTable = openFile (myPath + "User\\Object Table.txt")
		data = openFile (myPath + "Assets\\Asset Data.txt")
		singleArmLoc = "Both"
	)
	
	goodSyntax = getUserData()				
	
	print "***DIMS***"
	print Dims
	print "***VALS***"
	print Vals
	
	if testing then (
		close objTable
		close data
	)
	
)

--Description: Gets the user data from object table.txt in order to pass it to addInformation()
--Input: none
--Outputs: If the user entered good syntax, or if data needs to be re-entered
--Example Call: getUserData()
fn getUserData
objTable: objTable data: data	Dims: Dims= (
	
	--keeps track of the number of dimensions
	dimVal = 1
	--keeps track of what line in object table the function is on
	--Allows us to go back in the program if we'd like
	counter = 1
	
	--puts location of scanner at 0
	seek objTable 0
	seek data 0
	--goto first bracket
	skipToString objTable "["
	
	while not (eof objTable) do (
		
		infoAsString = ""
		
		--Lets us know if a given dimension defined in object table
		--was specified as a quaddle dimension by the user
		dimIncluded = true
		
		--get data in between brackets
		while (findString infoAsString "]" == undefined) do 
			infoAsString = infoAsString + readChar objTable
		
		--delete bracket in string 
		infoAsString = substring infoAsString 1 (infoAsString.count-1)
		--filterstring returns an array of strings parsed by the second arguement
		info = filterString infoAsString "," 
		
		--used for syntax error messaging (see if the user entered too high of a number)
		maxVal = findMaxVal()
		
		for i = 1 to info.count do (
			
			newVal = info[i]
			newVal = trimLeft newVal
			newVal = trimRight newVal
			newVal = toLower newVal
			
			--check syntax
			isGoodVal = checkVal(newVal)
			
			if isGoodVal then
				dimIncluded = addInformation(newVal)
			else	(
				
				--If there was incorrect syntax, return false
				close objTable
				close data
				return false
				
			)
			
		)
		
		if dimIncluded then (
			
			resetPosInFile()
			--get the name of the New Dimension
			newDim = readDelimitedString data ":"
			newDim = trimLeft newDim
			append Dims newDim
			dimVal = dimVal + 1
			
		)
		
		--goto next dimension value
		skipToString objTable "["
		counter = counter + 1
		
	)
	
	modifyArmCount()
	
	return true
	
)

--Description: Recieves the user values determined by getUserData() then uses that info
--					to fetch the corresponding Dimension and Value from asset table.txt
--Input: all implicit
--Outputs: true if a dimension was added, false if not
--Example Call: addInformation(val)
fn addInformation 
str dimVal: dimVal Vals: Vals Dims:Dims counter: counter = (

	resetPosInFile()
	
	--If user enters "none", there is no new dimension
	if doNotUseDim(str) then
		return false

	--If user enters "all", add all values from asset_data.txt
	if useAllValsInDim(str) then (
		
		while not endOfLine() do (
			
			nextVal()
			addDataToArray()
			
		)
		
		return true
		
	)
	
	--enter correct position in file
	nextVal()
	
	if isRange(str) then (
		
		rangeVals = filterString str "-"
		
		startVal = rangeVals[1] as integer
		endVal = rangeVals[2] as integer
		
		gotoVal( startVal as string )
		
		for i = startVal to endVal do (
			
			addDataToArray()
			nextVal()
			
		)
		
		return true
		
	)
	
	--else a singular number was entered, and 
	--we goto that value
	gotoVal(str)
	addDataToArray()
	
	return true
	
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

--Description: Recieves the user values determined by getUserData() then uses that info
--					to fetch the corresponding Dimension and Value from asset table.txt
--Input: all implicit
--Outputs: true if a dimension was added, false if not
--Example Call: addDataToArray()
fn addDataToArray dimVal:dimVal Vals: Vals = (
	
	if Vals[dimVal] == undefined then
		append Vals #()
	
	append Vals[dimVal] (readDelimitedString data "\"")
	
)

--Description: Modifies the Vals of Arm count based on the user preference
-- 					"Single Arm Location" to include "1L" (one left arm) or "1R"
--					(one right arm) or both.
--Input: none
--Outputs: none
--Example Call: modifyArmCount()
fn modifyArmCount = (
	
	if objHasArmCount() then (
		
		if (findItem Vals[ getArmCountLoc() ] "1" != 0) then (
			
			if singleArmLoc == "Left" or singleArmLoc == "Both" then
				insertItem "1L" (Vals[  getArmCountLoc()  ]) (findItem Vals[  getArmCountLoc()  ] "1")
			
			if singleArmLoc == "Right" or singleArmLoc == "Both" then
				insertItem "1R"  (Vals[  getArmCountLoc()  ] ) (findItem Vals[ getArmCountLoc() ] "1")
			deleteItem (Vals[ getArmCountLoc() ]) (findItem Vals[ getArmCountLoc() ] "1")
			
		)
		
	)

)

--Description: The function that checks for simple syntax errors. If you wish to 
--					add more syntax errors this is the place. 
--Input: userVal (an individual value that is determined by parsing commas in brackets in getUserData()). 
--			This is the value is checked. maxVal: the total number of possible enteries. For example maxVal will
--			Will be 16 when evaluating Icon dimensions because that is the number of possible values
--Outputs: true if the syntax is appropriate, false if not
--Example Call: checkVal(val)
fn checkVal userVal maxVal: maxVal = (
	
	if doNotUseDim(userVal) or useAllValsinDim(userVal) or isRange(userVal) then 
		return true
	
	
	if userVal as integer == undefined then (
		messageBox ("An invalid character was entered in the value: " + userVal)
		return false
	)
	
	userInt = userVal as integer
-- 	if (userInt < 0) then (
-- 		resetPosInFile()
-- 		messagebox ("The value \"" + userVal + "\" is too small for the dimension \"" + (readDelimitedString data ":") + "\"")
-- 		return false
-- 	)

	if (userInt >= maxVal) then (
		resetPosInFile()
		messagebox ("The value \"" + userVal + "\" is too large for the dimension \"" + (readDelimitedString data ":") + "\"")
		return false
	)
	
	return true
)

--Description: The second of round of error checking. It checks for logical misinputs like having
--					having a beak but no head. goodSyntax is included so that this code will not execute
--					until the syntax is corrected.
--Input: Dims, goodSyntax
--Outputs: true if the logic is appropriate, false if not
--Example Call: checkForErrors()

fn checkForErrors 
Dims: Dims goodSyntax: goodSyntax = (
	
	if goodSyntax == false then 
		return false
	
	local mybool = true
	
	if not objHasBody() then (
		
		messageBox "You must have a body"
		mybool = false
		return mybool
		
	)
	
	if objHasCompColour() and not objHasMainColour() then (
		
		messageBox "You must have Main Colour if you have a Comp Colour"
		mybool = false
		return mybool
		
	)
	
	if objHasPattern() and (not objHasCompColour() or not objHasMainColour() ) then (
		
		messageBox "You must have both main and comp colours to have a pattern"
		mybool = false
		return mybool
		
	)
	
	if not objHasArmCount() and
	   ( objHasArmAngle() or objHasArmEnds() ) then (
		
		messageBox "You must have an Arm Count dimension to have have an Arm Angle or Arm End "
		mybool = false
		return mybool
		
	)
	
	if not objHasBeak() and 
	  ( objHasBeakEnds() or objHasBeakAngle() ) then (
		
		messageBox "You must have a Head to have a Beak or Beak Angle"
		mybool = false
		return mybool
		
	)
	
	if not objHasBeak() and objHasBeakAngle() then (
		
		messageBox "You must have an Beak to have an Beak Angle"
		mybool = false
		return mybool
		
	)
	
	return mybool
	
)
