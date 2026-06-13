extends StaticBody3D
class_name BasePart

var BrickColor = {
	"Bright red" = Color(0.805, 0.109, 0.109, 1.0),
	"Bright purple" = Color(0.437, 0.112, 0.679, 1.0),
	"Bright blue" = Color(0.155, 0.31, 0.62, 1.0),
	"Bright yellow" = Color(0.93, 0.837, 0.0, 1.0),
	"Bright green" = Color(0.36, 0.73, 0.175, 1.0),
	"Brown" = Color(0.32, 0.179, 0.063, 1.0),
	"White" = Color(1.0, 1.0, 1.0, 1.0),
	"Steel grey" = Color(0.613, 0.613, 0.613, 1.0),
	"Flint" = Color(0.25, 0.25, 0.25, 1.0),
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var color
	if BrickColor.get(get_meta("BrickColor")):
		color = BrickColor.get(get_meta("BrickColor"))
	else: color = BrickColor.get("White")
	var material = load("res://content/textures/materials/plastic/plastic.res").duplicate()
	material.albedo_color = BrickColor.get(get_meta("BrickColor"))
	$PartMesh.set_surface_override_material(0, material)
	print("loaded Instance " + name + "!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
