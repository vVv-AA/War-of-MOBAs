// Created by Crowbar 0.29.0.0

$ModelName "props_vehicles\apache.mdl"

$BodyGroup "Body"
{
	studio "apache_reference.smd"
}


$SurfaceProp "metal"

$Contents "solid"

$MaxEyeDeflection 90

$MostlyOpaque

$CDMaterials "models\"

$Attachment "gun" "AH64.MGun" 0 0 0 rotate 0 -90 -90
$Attachment "muzzle" "AH64.MGun" 4.84 -50.9 -3.1 rotate 0 -90 -90
$Attachment "rocketpodl" "AH64.Fuselage" -40.24 -80.98 85.94 rotate 0 -90 -90
$Attachment "rocketpodr" "AH64.Fuselage" -40.24 -80.98 -85.94 rotate 0 -90 -90
$Attachment "lightpodl" "AH64.Fuselage" -20.24 -40.98 100.94 rotate 0 -90 -90
$Attachment "lightpodr" "AH64.Fuselage" -20.24 -40.98 -100.94 rotate 0 -90 -90
$Attachment "Damage0" "AH64.RRotor1" 0 0 0 rotate 0 0 0
$Attachment "Damage1" "AH64.Rotor" 0 0 0 rotate 0 0 0

$CBox 0 0 0 0 0 0

$BBox -382.779 -398.324 -99.51 443.714 398.318 148.694

// $HBoxSet "default"
// $HBox 0 "AH64.Fuselage" -50 -225 -85 50 285 85
// $HBox 0 "AH64.Rotor" 0 -281.660004 -281.649994 66.440002 281.640015 281.649994
// $HBox 1 "AH64.RRotor1" -63.209999 -62.470001 -0.5 62.709999 63.459999 28.540001
// $HBox 1 "AH64.RRotor2" -73.639999 -74.139999 -0.5 74.639999 74.139999 25.57
// $HBox 0 "AH64.MGunMount" -21.280001 -4.5 -6.77 0.16 3.73 5.88
// $HBox 0 "AH64.MGun" -7.88 -51.029999 -10.93 10.06 13.12 5.12


$PoseParameter "weapon_pitch" -5 80 0
$PoseParameter "weapon_yaw" -60 60 0
$PoseParameter "rudder" -45 45 0

$Animation "mdldecompiler_delta.smd" "apache_anims\mdldecompiler_delta.smd" {
	fps 30
}

$Animation "aim_up" "apache_anims\aim_up.smd" {
	fps 30
	// This subtract line guesses the animation name and frame index. There is no way to determine which $animation and which frame was used. Change as needed.
	subtract "mdldecompiler_delta.smd" 0
}

$Animation "aim_down" "apache_anims\aim_down.smd" {
	fps 30
	// This subtract line guesses the animation name and frame index. There is no way to determine which $animation and which frame was used. Change as needed.
	subtract "mdldecompiler_delta.smd" 0
}

$Animation "aim_right" "apache_anims\aim_right.smd" {
	fps 30
	// This subtract line guesses the animation name and frame index. There is no way to determine which $animation and which frame was used. Change as needed.
	subtract "mdldecompiler_delta.smd" 0
}

$Animation "aim_left" "apache_anims\aim_left.smd" {
	fps 30
	// This subtract line guesses the animation name and frame index. There is no way to determine which $animation and which frame was used. Change as needed.
	subtract "mdldecompiler_delta.smd" 0
}

$Animation "rudder_right" "apache_anims\rudder_right.smd" {
	fps 30
	// This subtract line guesses the animation name and frame index. There is no way to determine which $animation and which frame was used. Change as needed.
	subtract "mdldecompiler_delta.smd" 0
}

$Animation "rudder_left" "apache_anims\rudder_left.smd" {
	fps 30
	// This subtract line guesses the animation name and frame index. There is no way to determine which $animation and which frame was used. Change as needed.
	subtract "mdldecompiler_delta.smd" 0
}

$Sequence "idle" {
	"apache_anims\idle.smd"
	activity "ACT_IDLE" 1
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$Sequence "weapon_pitch" {
	"aim_up"
	"aim_down"
	autoplay
	blend "weapon_pitch" -5 80
	blendwidth 2
	delta
	fadein 0.2
	fadeout 0.2
	fps 30
	// This subtract line guesses the animation name and frame index. There is no way to determine which $animation and which frame was used. Change as needed.
	subtract "mdldecompiler_delta.smd" 0
}

$Sequence "weapon_yaw" {
	"aim_right"
	"aim_left"
	autoplay
	blend "weapon_yaw" -60 60
	blendwidth 2
	delta
	fadein 0.2
	fadeout 0.2
	fps 30
	// This subtract line guesses the animation name and frame index. There is no way to determine which $animation and which frame was used. Change as needed.
	subtract "mdldecompiler_delta.smd" 0
}

$Sequence "rudder" {
	"rudder_right"
	"rudder_left"
	autoplay
	blend "rudder" -45 45
	blendwidth 2
	delta
	fadein 0.2
	fadeout 0.2
	fps 30
	// This subtract line guesses the animation name and frame index. There is no way to determine which $animation and which frame was used. Change as needed.
	subtract "mdldecompiler_delta.smd" 0
}

$CollisionJoints "apache_physics.smd"
{
	$mass 2500
	$inertia 1
	$damping 0
	$rotdamping 0
	$concave

}

$CollisionText
{
	break 
	{
		"model" "models/gibs/apache_gibs/apache_fueselage.mdl"
		"health" "0"
		"debris" "2"
		"fadetime" "0"
		"multiplayer_break" "server"
	}
	break 
	{
		"model" "models/gibs/apache_gibs/apache_gun.mdl"
		"health" "0"
		"debris" "2"
		"fadetime" "0"
		"multiplayer_break" "server"
	}
	break 
	{
		"model" "models/gibs/apache_gibs/apache_tire.mdl"
		"health" "0"
		"debris" "2"
		"fadetime" "0"
		"multiplayer_break" "server"
	}
}
