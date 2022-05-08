-- Attention-Circuits-Control Laboratory (www.attention-circuits-control.org) --

--For more information on how Quaddles are generated and may be used:
--Watson, MR., Voloh, B., Naghizadeh, M., Womelsdorf, T., (2018) “Quaddles: A multidimensional 3D object set with parametrically-controlled
-- and customizable features” Behav Res Methods.

--Website guide: http://accl.psy.vanderbilt.edu/resources/analysis-tools/3d-image-material/
--Brief instructions on how to use scripts: http://accl.psy.vanderbilt.edu/quaddlegenerator-brief-instructions/

--Scripts, objects and in depth manual available on github: https://github.com/att-circ-contrl/Quaddles-Gen


--CREATES PICTURE OF EACH OBJECT SPECIFIED BY ANGLE AND DISTANCE
		
--making circle for camera to move on
testing = false
circ = circle()

if testing then (
	anglevalue = 20
)
if not testing then
	Obj.pivot = [0,0,0]

if headVal() == "No Head" or not objHasHead() then (
	targetPos = 0
	
)
else (
	targetPos = (-bodyZMin + hBodyZMax) / 3.5 
	if objHasHead() and bodyVal() == "Convex" then(
		camdistance = camdistance + 20
		targetPos = targetPos + 4
		)
	
)

circ.radius = abs (cos(anglevalue) * camdistance)
circ.pos = [0,0,(sin(anglevalue) * camdistance)]

-- if(objVals[findItem Dims "Aspect_Ratio"] == "Long") then
-- 	targetPos = targetPos - 5

cam = freeCamera()
cam.type = #target
cam.target.pos = [0,0,targetPos]

--path constraint
pc = path_constraint()
pc.path = circ --defining the path constraint
cam.position.controller = pc --camera  movement constrained to path constraint

if not testing then (
--since camera is locked to path constraint of the circle, rotating circle will move camera
viewport.setType #view_camera
anglestring = anglevalue as string
fileNameForPic2 =  fileNameForPic + "pictures\\" + anglestring
fileNameForPic = fileNameForPic + "pictures\\" + 0 as string

	makeDir fileNameForPic
	makeDir fileNameForPic2

--smoothhighlights is a render setting
viewport.SetRenderLevel #smoothhighlights
--picturelocation = fileNameForPic + "\\" + anglestring + "_0deg_rotation_" + picname + ".jpg"
picturelocation = fileNameForPic + "\\" + anglestring + "_0deg_rotation_" + picname + ".png"

render outputFile: (picturelocation) vfb: off outputSize: [1280,720]


rotate Obj (eulerAngles 0 0 45)
--picturelocation = fileNameForPic2 + "\\" + anglestring + "_45deg_rotation_" + picname + ".jpg"
picturelocation = fileNameForPic2 + "\\" + anglestring + "_45deg_rotation_" + picname + ".png"

render outputFile: (picturelocation) vfb: off outputSize: [1280,720]
)
delete circ
delete cam
	
	