## Base class for all rendered physics objects in the Workspace.

@icon("res://content/textures/editor/BasePart.png")
extends RigidBody3D
class_name BasePart

enum PartShape {
	Block,
	Head,
	Wedge,
	Cylinder,
	Sphere
}

@export var Locked:bool = false
@export var Intangible:bool = false ## Whether or not the part can be collided with.

@export var Position:Vector3
@export var PivotOffset:Vector3
@export var Size:Vector3 = Vector3(2, 1, 4)
@export var Rotation:Vector3

@export var Opacity:float = 1.0 ## How opaque the part is.
@export var BrickColor:Color = Color.WEB_GRAY ## What color the part is.
@export var Shape:PartShape = PartShape.Block ## What shape the part will take. Overridden when using a FileMesh, and cant be changed when the game is running.
@export var ShowBuiltInDecals:bool = true

func _init(size:Vector3 = Vector3(2, 1, 4), pos:Vector3 = Vector3(0, 0, 0), anchored:bool = false) -> void:
	Size = size
	Position = pos
	Locked = anchored

var PartHitbox = CollisionShape3D.new()
var CollisionShape = BoxShape3D.new()

var PartMesh:MeshInstance3D
var PartMaterial:StandardMaterial3D = load("res://content/textures/materials/plastic/plastic.res").duplicate()

func UpdateVisuals():
	PartMaterial.albedo_color = Color(BrickColor, Opacity)
	
	match Shape:
		PartShape.Block:
			if not PartMesh:
				PartMesh = load("res://content/places/CubePartMesh.tscn").instantiate()
			PartMesh.scale = Size
			PartMesh.material_override = PartMaterial
			
			var Surfaces:Node3D = PartMesh.get_node("Surfaces")
			Surfaces.scale = Vector3(1 / Size.x, 1, 1 / Size.z)
			
			for Surface:Sprite3D in Surfaces.get_children():
				Surface.region_rect = Rect2(0, 0, 16 * Size.x, 16 * Size.z)
		PartShape.Cylinder:
			if not PartMesh:
				PartMesh = load("res://content/places/CylinderPartMesh.tscn").instantiate()
			PartMesh.scale = Size
			PartMesh.material_override = PartMaterial
			
			var Surfaces:Node3D = PartMesh.get_node("Surfaces")
			Surfaces.scale = Vector3(1 / Size.x, 1, 1 / Size.z)
			
			for Surface:Sprite3D in Surfaces.get_children():
				Surface.region_rect = Rect2(0, 0, 16 * Size.x, 16 * Size.z)
		PartShape.Sphere:
			if not PartMesh:
				PartMesh = load("res://content/places/SpherePartMesh.tscn").instantiate()
			PartMesh.scale = Vector3.ONE * Size.x
			PartMesh.material_override = PartMaterial
		PartShape.Head:
			if not PartMesh:
				PartMesh = load("res://content/places/HeadSpecialMesh.tscn").instantiate()
			PartMesh.scale = Vector3.ONE * Size.y
			
			PartMesh.material_override = PartMaterial
	
	if not ShowBuiltInDecals:
		for v in PartMesh.get_children():
			if v is Decal: v.visible = false
		
		if PartMesh.has_node("Surfaces"): PartMesh.get_node("Surfaces").visible = false
	else:
		for v in PartMesh.get_children():
			if v is Decal: v.visible = true
		
		if PartMesh.has_node("Surfaces"): PartMesh.get_node("Surfaces").visible = true

# Events

signal Touched ## Fires when this part is touched by another part.

func OnTouch(body: Node) -> void:
	if body is BasePart:
		Touched.emit(body)

func FindFirstChildOfClass(classname:String):
	for v in get_children():
		if v.is_class(classname):
			return v
			break

func Rotate(NewRotation): ## Sets a part's rotation in degrees.
	rotation_degrees = NewRotation

func Move(NewPosition): ## Sets a part's rotation in degrees.
	global_position = NewPosition

func _ready() -> void:
	PartHitbox.shape = CollisionShape
	CollisionShape.size = Size
	add_child(PartHitbox)
	UpdateVisuals()
	
	connect("body_entered", OnTouch)
	add_child(PartMesh)

func _process(delta: float) -> void: # visuals
	if PartMaterial.albedo_color != Color(BrickColor, Opacity):
		PartMaterial.albedo_color = Color(BrickColor, Opacity)
	
	UpdateVisuals()

func _physics_process(delta: float) -> void:
	Position = global_position
	Rotation = rotation_degrees
	
	PartHitbox.disabled = Intangible
	freeze = Locked
	
	PartMesh.position = -PivotOffset
	PartHitbox.position = -PivotOffset
