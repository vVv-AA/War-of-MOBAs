// Created by Crowbar 0.29.0.0

$ModelName "props_vehicles\tiger_tank.mdl"

$StaticProp

$BodyGroup "Body"
{
	studio "tiger_tank_reference.smd"
}

$LOD 30
{
	replacemodel "tiger_tank_reference.smd" "tiger_tank_reference_lod1.smd"
}
$LOD 55
{
	replacemodel "tiger_tank_reference.smd" "tiger_tank_reference_lod2.smd"
}
$LOD 75
{
	replacemodel "tiger_tank_reference.smd" "tiger_tank_reference_lod3.smd"
}

$SurfaceProp "metal"

$Contents "solid"

$MaxEyeDeflection 90

$CDMaterials "models\props_vehicles\"

$CBox 0 0 0 0 0 0

$BBox -128.717 -73.54 -1.69 224.175 75.427 115.305


$Sequence "idle" {
	"tiger_tank_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$CollisionModel "tiger_tank_physics.smd"
{
	$mass 1
	$inertia 1
	$damping 0
	$rotdamping 0
	$concave

}
