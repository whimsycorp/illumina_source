extends StaticBody3D
class_name BasePart
@onready var BrickColor = PartValues.BrickColor

signal clicked

func getOpacity():
	return float(get_meta("Opacity"))
	
func getBrickColor():
	return BrickColor[get_meta("BrickColor")]

func getCollidable():
	var result
	if get_meta("CanCollide") is bool:
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
