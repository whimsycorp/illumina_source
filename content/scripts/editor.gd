extends Node3D
@onready var insert_part: Button = $Control/Panel/InsertPart
@onready var workspace: Node = $Workspace

@onready var sx: LineEdit = $Control/Panel/Size/X
@onready var sy: LineEdit = $Control/Panel/Size/Y
@onready var sz: LineEdit = $Control/Panel/Size/Z
@onready var check_button: CheckButton = $Control/Panel/CheckButton
@onready var color: LineEdit = $Control/Panel/color
@onready var opacity: LineEdit = $Control/Panel/Opacity

var selected:Node3D
var Instances = {}

var editing = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sx.editing_toggled.connect(editing_toggle)
	sy.editing_toggled.connect(editing_toggle)
	sz.editing_toggled.connect(editing_toggle)
	color.editing_toggled.connect(editing_toggle)
	opacity.editing_toggled.connect(editing_toggle)
	filename.editing_toggled.connect(editing_toggle)

const move_step = 0.5

@onready var node:Node3D = $Node3D
var zoomMultiplier = 0
var zoomExtents = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if editing:
		return
	
	# Camera control
	
	if Input.is_action_just_pressed("EditorTurnCamE"):
		node.rotation_degrees += Vector3(0, 15, 0)
	
	if Input.is_action_just_pressed("EditorTurnCamQ"):
		node.rotation_degrees -= Vector3(0, 15, 0)
	
	if Input.is_action_just_pressed("zoomIn"):
		if zoomMultiplier >= -zoomExtents:
			$Node3D.scale /= 2
			zoomMultiplier -= 1
	
	if Input.is_action_just_pressed("zoomOut"):
		if zoomMultiplier <= zoomExtents:
			$Node3D.scale *= 2
			zoomMultiplier += 1
	
	# Instance control
	
	if Input.is_action_just_pressed("ui_up"):
		selected.position += Vector3(0, 0, -move_step)
	
	if Input.is_action_just_pressed("ui_down"):
		selected.position += Vector3(0, 0, move_step)
	
	if Input.is_action_just_pressed("ui_left"):
		selected.position += Vector3(-move_step, 0, 0)
	
	if Input.is_action_just_pressed("ui_right"):
		selected.position += Vector3(move_step, 0, 0)
	
	if Input.is_action_just_pressed("forward"):
		selected.position += Vector3(0, move_step, 0)
	
	if Input.is_action_just_pressed("back"):
		selected.position += Vector3(0, -move_step, 0)
	
	if Input.is_action_just_pressed("rotate"):
		selected.rotation_degrees += Vector3(0, 90, 0)
	
	if Input.is_action_just_pressed("tilt"):
		selected.rotation_degrees += Vector3(0, 0, 90)

func _on_insert_pressed() -> void:
	var BasePart = load("res://content/places/basePart.tscn")
	var newPart:StaticBody3D = BasePart.instantiate()
	newPart.set_meta("BrickColor", "Steel grey")
	newPart.scale = Vector3(2, 1, 4)
	workspace.add_child(newPart)
	
	Instances[Instances.size()] = newPart
	selected = newPart
	
	sx.text = str(selected.scale.x)
	sy.text = str(selected.scale.y)
	sz.text = str(selected.scale.z)
	
	newPart.connect("clicked", func():
		selected = newPart
		)

func x_submitted(new_text: String) -> void:
	selected.scale.x = float(new_text)

func y_submitted(new_text: String) -> void:
	selected.scale.y = float(new_text)

func z_submitted(new_text: String) -> void:
	selected.scale.z = float(new_text)

func color_submitted(new_text: String) -> void:
	selected.set_meta("BrickColor", new_text)

func editing_toggle(toggled:bool):
	editing = toggled

func cancollide_toggled(toggled_on: bool) -> void:
	selected.set_meta("CanCollide", toggled_on)

func opacity_submitted(new_text: String) -> void:
	selected.set_meta("Opacity", float(new_text))

func _on_clone_pressed() -> void:
	var newPart = selected.duplicate()
	newPart.position += Vector3(0, newPart.scale.y, 0)
	workspace.add_child(newPart)
	
	Instances[Instances.size()] = newPart
	selected = newPart
	newPart.connect("clicked", func():
		selected = newPart
		)

@onready var filename: LineEdit = $Control/Panel/filename

func _on_export() -> void:
	var fileName
	if filename.text != "":
		fileName = filename.text
	else: fileName = "NewPlace"
	
	$IONExport.export_to_file(fileName, workspace)
