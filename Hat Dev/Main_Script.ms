--QuaddleGenerator

-- Attention-Circuits-Control Laboratory (www.attention-circuits-control.org) --
--Objects are all generated using 3ds Max 2017, and its inbuilt Maxscript--

--For more information on how Quaddles are generated and may be used:
--Watson, MR., Voloh, B., Naghizadeh, M., Womelsdorf, T., (2018) “Quaddles: A multidimensional 3D object set with parametrically-controlled
-- and customizable features” Behav Res Methods.

--Website guide: http://accl.psy.vanderbilt.edu/resources/analysis-tools/3d-image-material/
--Brief instructions on how to use scripts: http://accl.psy.vanderbilt.edu/quaddlegenerator-brief-instructions/

--Scripts, objects and in depth manual available on github: https://github.com/att-circ-contrl/Quaddles-Gen

--Copyright (C) 2017 Milad Naghizadeh, Marcus Watson, Ben Voloh, Thilo Womelsdorf, Attention Circuits Control Lab

--Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
--to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
--of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

--The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

--THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
--WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
--HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
--OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

copyrightSchpiel = "QuaddleGenerator\n\n" + \
"Copyright \xa9 2017 Milad Naghizadeh, Marcus Watson, Ben Voloh, Thilo Womelsdorf, Attention Circuits Control Lab\n\n" + \
"Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\")," + \
"to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies" + \
" of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\n" + \
"The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\n" + \
"THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE" + \
" WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT" + \
" HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT" + \
" OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n\n"
print copyrightSchpiel

--Functions are in other script
fileIn "Functions_List.ms"

try (closeRolloutFloater rof) catch()

rof=newrolloutfloater "Copyright notice" 800 300
rollout copyRight "Copyright License" width:800 height:300
	

(
	label 'mitInfo' copyrightSchpiel pos:[39,13] width:731 height:209 style_sunkenedge:false align:#left
	button 'continueButton' "Continue"
	on continueButton pressed do
	(
		(
			--FOLDER PATHS--FOLDER PATHS--FOLDER PATHS !!!
			--all scripts need to be in sysInfo.currentdir
			sysInfo.currentdir = "C:\\Users\\zachs\\Documents\\Lab\\Quaddle_2.0.2\\Hat Dev\\"
			savePathBase =  "C:\\Users\\zachs\\Documents\\Lab\\Quaddle_2.0.2\\Hat Dev\\images\\"
			makeDir savePathBase
			--textures for main body
			textureMainPath =  "C:\\Users\\zachs\\Documents\\Lab\\Quaddle_2.0.2\\Hat Dev\\Patterns and Object Table\\Patterns and Colours\\"
			objTable = openFile "C:\\Users\\zachs\\Documents\\Lab\\Quaddle_2.0.2\\Hat Dev\\Patterns and Object Table\\object_table.txt"

			dims = #("Body", "Colour", "Pattern",  "Arm_Angle","Hat")
			vals = #(#("Oblong","Pyramidal"),#("More_Red","More_Orange"),#("Diamond","Checkered"),#("Bent_Up","Bent_Down"),#("Oblong","Pyramidal"))
				
				print dims
			--if objects are set to be transparent, this number will determine how transparent the objects will be
			transparencyAmount = 25	
			objNames = #()
			--if you wish to make a custom object that is intermediate between shapes, you have to set one of the body dimensions as custom...
			--...and put in custom values here
			--Values must add up to 1!
			customObjectPercentages = #()
			pyramidpercentage = 0; 
			append customObjectPercentages pyramidpercentage;
				
			oblongpercentage = 0.2;
			append customObjectPercentages oblongpercentage;
				
			concavepercentage = 0.4;
			append customObjectPercentages oblongpercentage;
				
			octahedronpercentage = 0; 
			append customObjectPercentages octahedronpercentage;
				
			cubepercentage = 0.2; 
			append customObjectPercentages cubepercentage;
			
			spherepercentage= 0.2;
			append customObjectPercentages spherepercentage;


			if (objTable == undefined) then
				readTheTable = false
			else
				readTheTable = true
								
			global objVals = #()
			global allObjects = #()
				
			if (readTheTable == true) do (
				savePathFinal = savePathBase
				seek objTable 0
				while not(eof objTable) do (
					objDetails = readLine objTable
					for dimCount = 1 to ((objDetails.count + 1)/2) do (
						objVals[dimCount] = vals[dimCount][objDetails[((2*dimCount)-1)] as integer +1]
						print objVals[dimCount]
					)
					--print objDetails				
					MakeObject()
					
					)
			)
		)
		closeRolloutFloater rof
	)
)
addRollout copyRight rof rolledUp:off
	