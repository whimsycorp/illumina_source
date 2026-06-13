extends StaticBody3D
class_name BasePart

var BrickColor = {
	"Bright red" = Color(0.805, 0.109, 0.109, 1.0),
	"Bright purple" = Color(0.437, 0.112, 0.679, 1.0),
	"Bright blue" = Color(0.155, 0.31, 0.62, 1.0),
	"Bright yellow" = Color(0.93, 0.837, 0.0, 1.0),
	"Bright green" = Color(0.36, 0.73, 0.175, 1.0),
	"Brown" = Color(0.32, 0.179, 0.063, 1.0),
	"Tan" = Color(0.87, 0.746, 0.583, 1.0),
	"White" = Color(1.0, 1.0, 1.0, 1.0),
	"Steel grey" = Color(0.613, 0.613, 0.613, 1.0),
	"Flint" = Color(0.25, 0.25, 0.25, 1.0),
}

signal clicked

func getOpacity():
	return float(get_meta("Opacity"))
	
func getBrickColor():
	return BrickColor[get_meta("BrickColor")]

func getCollidable():
	var result
	if get_meta("CanCollide") == true or get_meta("CanCollide") == false:
		return get_meta("CanCollide")
	
	if get_meta("CanCollide") == "true":
		result = true
	else: result = false
	return result

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var color = getBrickColor()
	var opacity = getOpacity()
	var collidable = getCollidable()
	
	var material:BaseMaterial3D = load("res://content/textures/materials/plastic/plastic.res").duplicate()
	material.albedo_color = Color(color, opacity)
	if opacity != 1.0:
		material.set_transparency(BaseMaterial3D.TRANSPARENCY_ALPHA)
	
	if !collidable:
		$CollisionMesh.disabled = true
	
	$PartMesh.set_surface_override_material(0, material)


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("leftClick"):
		print(str("clicked ", name))
		clicked.emit()
