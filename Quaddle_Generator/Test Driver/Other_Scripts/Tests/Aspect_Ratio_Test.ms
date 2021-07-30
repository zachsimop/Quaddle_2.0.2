clearListener()

ratios = #(0.3, 0.2, 0, -0.2, -0.3)

for i = 1 to ratios.count do (
	
-- 	temp = makeOblongBody(ratios[i])
-- 	temp[2].pos = [0, (i-1)*40, 0]
	
	
	temp = makePyramidBody(ratios[i])
	temp[2].pos = [0, (i-1)*40, 100]
	
	
-- 	temp = makeOctahedronBody(ratios[i])
-- 	temp[2].pos = [0, (i-1)*40, 200]
-- 	
-- 	
-- 	temp = makeCubicBody(ratios[i])
-- 	temp[2].pos = [0, (i-1)*40, 300]
-- 	
-- 	
-- 	temp = makeConvexBody(ratios[i])
-- 	temp[3].pos = [0, (i-1)*40, 400]
-- 	
-- 	
-- 	temp = makePepperBody(ratios[i])
-- 	temp[3].pos = [0, (i-1)*40, 500]
-- 	
-- 	
-- 	temp = makeCompressedOblongBody(ratios[i])
-- 	temp[2].pos = [0, (i-1)*40, 600]
-- 	
-- 	
-- 	temp = makeSphereBody(ratios[i])
-- 	temp[2].pos = [0, (i-1)*40, 700]
-- 	
-- 	
-- 	temp = makeConcaveBody(ratios[i])
-- 	temp[2].pos = [0, (i-1)*40, 800]
	
	
)

fn MakeOblongBody  ratio = (
	--Description: Makes Oblong main body
	--Input: 
	--Example Call: MakeOblongBody() will create the object
	-- all the Make___Body functions follow a similar 
	include "Script_OblongBody.ms"
)

fn MakePyramidBody  ratio = (
	include "Script_PyramidalBody.ms"
)

fn MakeOctahedronBody  ratio = (
	include "Script_OctahedronBody.ms"
)	

fn MakeCubicBody  ratio = (
	include "Script_CubicBody.ms"
)

fn MakeDumbbellBody  ratio = (
	include "Script_DumbbellBody.ms"
)

fn MakeConvexBody  ratio = (
	include "Script_ConvexBody.ms"
)
fn MakePepperBody  ratio = (
	include "Script_PepperBody.ms"
)
fn MakeCompressedOblongBody  ratio = (
	include "Script_CompressedOblongBody.ms"
)

fn MakeSphereBody  ratio = (
	include "Script_SphereBody.ms"
)

fn MakeConcaveBody  ratio = (
	include "Script_ConcaveBody.ms"
)