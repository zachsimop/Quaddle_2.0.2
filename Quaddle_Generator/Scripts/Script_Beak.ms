		
		if findItem Dims "Beak_Angle" != 0 then (
			arms = objVals[findItem Dims "Beak_Angle"]
		)
		else (
			arms = "Straight"
		)
		
		if findItem Dims "Beak_Ends" != 0 then (
			armEnds = objVals[findItem Dims "Beak_Ends"]
		)
		else (
			armEnds = "Flat"
	)
		

local beak= Cone()
	
	beak.radius1 = startradius
	beak.radius2 = endradius
	beak.height = 25
	beak.heightsegs = 20
	beak.sides = 40 -- 3 sides makes a triangular cross section, 4 sides makes cubic cross section and many sides makes a circular cross section
	addmodifier beak (bend angle: bendAngle)
	--naming beaks
	--beak.name = objName + "_beak001"
	
	if endradius > 0 then
		beak.height = 25
	
	if endradius == 0 then 
		beak.height = 30

-- 	if (bendAngle > 0) then
-- 		beak.name = "Upwards_beak "

-- 	if (bendAngle < 0) then
-- 		beak.name = "Downwards_beak "
	
	--Branches made darker from 70 70 70 to 15 15 15
	--old way of dding color was to add it directly instead of refering to png; but it wasn't exporting for some reason
	--beak.material = standardMaterial diffuse:(color 15 15 15)
	
	branchPath= assetPath + "Patterns and Colours\\" + "70_70_70" + ".png"
	beak.material = standardMaterial diffuseMap:(Bitmaptexture fileName: (branchPath)) showInViewport:true;
	rotate beak (eulerangles 0 90 0)
	protrusionAmount = 5

	scale beak [0.5,0.5,0.5]
	local offsetVal = 2.5
	if(objVals[findItem Dims "Head"] == "Cubic") then (
		offsetVal = 7.25
	)
	if(objVals[findItem Dims "Head"] == "Concave") then (
		offsetVal = 3.5
	)
	
	beak.pos = [(headBody.max[1] - offsetVal),0,((headBody.max[3] + headBody.min[3])/2)]
	return beak
	
