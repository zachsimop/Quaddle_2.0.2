--QuaddleGenerator

-- Attention-Circuits-Control Laboratory (www.attention-circuits-control.org) --
--Objects are all generated using 3ds Max 2021, and its inbuilt Maxscript--

--For more information on how Quaddles are generated and may be used:
-- Simopoulos, Z.,Watson, MR., Voloh, B., Naghizadeh, M., Womelsdorf, T., (2021) “Quaddles: A multidimensional 3D object set with parametrically-controlled
-- and customizable features” Behav Res Methods.

--Website guide: http://accl.psy.vanderbilt.edu/resources/analysis-tools/3d-image-material/
--Brief instructions on how to use scripts: http://accl.psy.vanderbilt.edu/quaddlegenerator-brief-instructions/

--Scripts, objects and in depth manual available on github: https://github.com/att-circ-contrl/Quaddles-Gen

--Copyright (C) 2021 Milad Naghizadeh, Marcus Watson, Ben Voloh, Thilo Womelsdorf, Attention Circuits Control Lab

--Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
--to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
--of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

--The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

--THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
--WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
--HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
--OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

--Functions are in other script
fileIn "FunctionsList.ms"
fileIn "Helper_Functions.ms"
fileIn "Init.ms"

clearListener()


copyrightSchpiel = "QuaddleGenerator\n\n" + \
"Copyright \xa9 2017 Zachary Simopoulos, Milad Naghizadeh, Marcus Watson, Ben Voloh, Thilo Womelsdorf, Attention Circuits Control Lab\n\n" + \
"Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\")," + \
"to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies" + \
" of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\n" + \
"The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\n" + \
"THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE" + \
" WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT" + \
" HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT" + \
" OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n\n"
print copyrightSchpiel

try (closeRolloutFloater rof) catch()

rof=newrolloutfloater "Copyright notice" 800 300
rollout copyRight "Copyright License" width:800 height:300
	
(
	label 'mitInfo' copyrightSchpiel pos:[39,13] width:731 height:209 style_sunkenedge:false align:#left
	button 'continueButton' "Go"
	on continueButton pressed do
	(
		(
			
			--Where you enter your Path!
			generatorPath = "C:\\Users\\zachs\\Documents\\Lab\\Quaddle_2.0.2\\Quaddle_Generator\\"
			
			--sdf
			loadInPathsFilesAndPreferences()
			loadInAssets() 
			loadInConstantsAndDefaults()
			
			readyToGo = checkForErrors()
			
			if readyToGo then (
				
				objVals = initObjVals()
				tempDims = deepCopy Dims
				
				createObjects()
				
				printNongeneratedObjects()
				
				print "Done"
				
			) else (
				
				messageBox "Please Fix Errors Before Continuing"
				
			)
			
			close pref
			close objTable
			close data
			
		)
		
		closeRolloutFloater rof
		
	)
	
)
addRollout copyRight rof rolledUp:off	