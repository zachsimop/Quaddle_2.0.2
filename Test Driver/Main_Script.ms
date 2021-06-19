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

--Functions are in other script
fileIn "FunctionsList.ms"

try (closeRolloutFloater rof) catch()

rof=newrolloutfloater "Copyright notice" 800 300
rollout copyRight "Copyright License" width:800 height:300
	
(
	label 'mitInfo' "Yo" pos:[39,13] width:731 height:209 style_sunkenedge:false align:#left
	button 'continueButton' "Go"
	on continueButton pressed do
	(
			--FOLDER PATHS--FOLDER PATHS--FOLDER PATHS !!!
			--all scripts need to be in sysInfo.currentdir
			sysInfo.currentdir = "C:\\Users\\zachs\\Documents\\Lab\\Quaddle_2.0.1\\Test Driver\\"
			savePathBase =  "C:\\Users\\zachs\\Documents\\Lab\\Quaddle_2.0.1\\Test Driver\\images\\"
			makeDir savePathBase
			--textures for main body
			textureMainPath =  "C:\\Users\\zachs\\Documents\\Lab\\Quaddle_2.0.1\\Test Driver\\Patterns and Object Table\\Patterns and Colours\\"
			objTable = openFile "C:\\Users\\zachs\\Documents\\Lab\\Quaddle_2.0.1\\Test Driver\\Patterns and Object Table\\object_table.txt"

			QuaddleDims = #("Body", "Colour", "Pattern",  "Arm_Angle","Arm_Ends")
			QuaddleVals = #(#("Oblong","Pyramidal"),#("More_Red","More_Orange"),#("Diamond","Checkered"),#("Bent_Up","Bent_Down"), #("Flat", "Blunt", "Pointed", "Flared"))

			PedastalDims = #("Character","Arm_Ends")
			PedastalVals = #(#("Chinese_Letter1.png","Chinese_Letter2.png"),#("Flat", "Blunt", "Pointed", "Flared"))
				
			ShapeDims = #("Shape")
			ShapeVals = #("Cone","Pyramid","Hedra","Pentagon","Gengon","Carrot","Spring")			
				
			--if objects are set to be transparent, this number will determine how transparent the objects will be
			transparencyAmount = 25	
			objNames = #()
				
			--if you wish to make a custom object that is intermediate between shapes, you have to set one of the body dimensions as custom...
			--...and put in custom values here
			--Values must add up to 1!
			customObjectPercentages = #()
			customObjecetPercentages = loadCustomPercentages()
						
			shapeTexture= Bitmaptexture  fileName: (textureMainPath + "70_70_70.png")	
			shapeMaterial = standardMaterial diffuseMap:(shapeTexture) showInViewport:true;

			if (objTable == undefined) then
				readTheTable = false
			else
				readTheTable = true
				
			if (readTheTable == true) then (

				seek objTable 0
				genAtNullLoc = true
				
				--The Array that Stores the Values of the object being created
				--The Program reads from this Array to create the objects
				objVals = #()
				
				--The Array where the actual object componets are stored
				obj = #()
				
				--The Array that stores the obj arrays to build the totem pole structure
				objStack = #()
				
				objName = ""
				stackNum = 1
				genLoc = 0
				newObject = "---"
				endTable = "***"
				
				while(eof objTable == false) do (
					
					--Read in Object Information
					objData = readLine objTable
					
					if (objData == newObject or objData == endTable) then ( 

						Takepics (20) (genLoc*3) --genLoc*3 in the distance parameter roughly 
						ExportObject()				   --allows the camera to adjust to different stack heights
						deleteObjStack()
						print objName

						--Reset Variables for the next object
						objName = ""
						genAtNullLoc = True
						genLoc = 0
						
						if (objData == newObject) then 
							objData = readLine objTable
						
					) 

					if(stackNum > 1) then 
						genAtNullLoc = false
					
					if(objData != endTable) then (					
						
						--Generate Quaddle 
						if( isQuaddle() ) then 
							obj = generateQuaddle()

						--Generate Pedastal
						if( isPedastal() ) then 
							obj = generatePedastal()

						--Generate Shape Object
						if( isShape() ) then 
							obj = generateShape()
						
						--Move the object to the correct position on the Totem Sturcture
						genLoc = moveObj()
						
						objName = generateName()
						
						append objStack obj
						stackNum = stackNum + 1
						
					)	
				)
			
			)
		closeRolloutFloater rof
	)
)
addRollout copyRight rof rolledUp:off	