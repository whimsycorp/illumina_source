## Base class for all rendered physics objects in the Workspace.

extends RigidBody3D
class_name BasePart

enum PartShape {
	Block,
	Wedge,
	Cylinder,
	Sphere
}

@export var Locked:bool = false
@export var Intangible:bool = true ## Whether or not the part can be collided with.

@export var Position:Vector3
@export var Size:Vector3 = Vector3(2, 1, 4)
@export var Rotation:Vector3

@export var Opacity:float = 1.0 ## How opaque the part is.
@export var BrickColor:Color = Color.WEB_GRAY ## What color the part is.
@export var Shape:PartShape = PartShape.Block ## What shape the part will take. Overridden when a SpecialMesh is a child of the part.

var PartHitbox = CollisionShape3D.new()
var CollisionShape = BoxShape3D.new()

var PartMesh:MeshInstance3D
var PartMaterial:StandardMaterial3D = load("res://content/textures/materials/plastic/plastic.res").duplicate()

func _ready() -> void:
	PartHitbox.shape = CollisionShape
	CollisionShape.size = Size
	add_child(PartHitbox)
	
	match Shape:
		PartShape.Block:
			PartMaterial.albedo_color = Color(BrickColor, Opacity)
			
			PartMesh = load("res://content/places/CubePartMesh.tscn").instantiate()
			PartMesh.scale = Size
			PartMesh.material_override = PartMaterial
			
			var Surfaces:Node3D = PartMesh.get_node("Surfaces")
			Surfaces.scale = Vector3(Size.x / 1, 1, Size.x / 1)
			
			for Surface:Sprite3D in Surfaces.get_children():
				Surface.region_rect = Rect2(0, 0, 16 * Size.x, 16 * Size.z)
	
	add_child(PartMesh)

func _process(delta: float) -> void: # visuals
	position = Position
	rotation_degrees = Rotation
	
	if PartMaterial.albedo_color != Color(BrickColor, Opacity):
		PartMaterial.albedo_color = Color(BrickColor, Opacity)
	
	PartHitbox.disabled = Intangible
	freeze = Locked
	
	
	
