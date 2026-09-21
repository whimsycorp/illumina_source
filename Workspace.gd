## Container class for all instances that are accounted for in rendering and physics processing.

@icon("res://content/textures/editor/DataModel.png")
extends Model
class_name Workspace

@export var Gravity : float = 196.2 ## Determines the acceleration due to the gravity applied to falling BaseParts.
@export var DistributedGameTime : int = 0 ## The amount of time the game has been running in seconds. Server-side how long the server has been up, client-side how long the player has been connected.
@export var CurrentCamera : Camera3D = load("res://content/instances/Camera.tscn").instantiate() ## The currently focused camera. Almost exclusively used client-side, never changes in most circumstances.

@export var FallenPartsDestroyDepth : float = -1000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	add_child(BasePart.new(Vector3(128, 8, 128), Vector3.DOWN * 4, true))
	
	add_child(BasePart.new(Vector3(4, 4, 4)))
	
	add_child(CurrentCamera)

func GetDescendants():
	return find_children("*")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	for Instance in GetDescendants():
		if Instance is BasePart:
			if Instance.Position.y <= FallenPartsDestroyDepth:
				Instance.queue_free()
