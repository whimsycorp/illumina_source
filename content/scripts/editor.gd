extends Node3D
@onready var insert_part: Button = $Control/Panel/InsertPart
@onready var workspace: Node = $Workspace

@onready var sx: LineEdit = $Control/Panel/Size/X
@onready var sy: LineEdit = $Control/Panel/Size/Y
@onready var sz: LineEdit = $Control/Panel/Size/Z
@onready var check_button: CheckButton = $Control/Panel/CheckButton
@onready var color: OptionButton = $Control/Panel/BrickColor
@onready var opacity: LineEdit = $Control/Panel/Opacity
@onready var partname: LineEdit = $Control/Panel/partname
@onready var explorer: ItemList = $Control/Explorer
@onready var ray: RayCast3D = $ray
@onready var camera: Camera3D = $Node3D/EditorView
@onready var clone_ray: RayCast3D = $cloneRay

var selected:Node3D
var Instances = {}

var editing = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sx.editing_toggled.connect(editing_toggle)
	sy.editing_toggled.connect(editing_toggle)
	sz.editing_toggled.connect(editing_toggle)
	opacity.editing_toggled.connect(editing_toggle)
	partname.editing_toggled.connect(editing_toggle)
	
	
	for brickColor in PartValues.BrickColor:
		color.add_item(brickColor, color.item_count)

var move_step = 0.5

var zoomMultiplier = 0
var zoomExtents = 3
var CameraControlled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if editing:
		return
	
	if Input.is_action_pressed("ctrl"):
		move_step = 0.5
	else: move_step = 1
	
	if Input.is_action_pressed("rightClick"):
		CameraControlled = true
	else: CameraControlled = false
	
	# Instance control
	
	if Input.is_action_just_pressed("rotate"):
		selected.rotation_degrees += Vector3(0, 90, 0)
	
	if Input.is_action_just_pressed("tilt"):
		selected.rotation_degrees += Vector3(0, 0, 90)
	
	if Input.is_action_pressed("forward"):
		$Node3D.position -= $Node3D.transform.basis.z * 1
	
	if Input.is_action_pressed("back"):
		$Node3D.position += $Node3D.transform.basis.z * 1
	
	if Input.is_action_pressed("strafeLeft"):
		$Node3D.position -= $Node3D.transform.basis.x * 1
	
	if Input.is_action_pressed("strafeRight"):
		$Node3D.position += $Node3D.transform.basis.x * 1
	
	if selected == null: return
	
	if Engine.get_process_frames() % 2 == 0:
		if Input.is_action_pressed("ui_up"):
			selected.position += Vector3(0, 0, -move_step)
		
		if Input.is_action_pressed("ui_down"):
			selected.position += Vector3(0, 0, move_step)
		
		if Input.is_action_pressed("ui_left"):
			selected.position += Vector3(-move_step, 0, 0)
		
		if Input.is_action_pressed("ui_right"):
			selected.position += Vector3(move_step, 0, 0)
		
		if Input.is_action_pressed("EditorTurnCamE"):
			selected.position += Vector3(0, move_step, 0)
	
		if Input.is_action_pressed("EditorTurnCamQ"):
			selected.position += Vector3(0, -move_step, 0)

func _physics_process(delta: float) -> void:
	for node in workspace.get_children():
		if node == selected:
			node.set_collision_layer_value(1, false)
			node.set_collision_layer_value(16, true)
		else: 
			node.set_collision_layer_value(16, false)
			node.set_collision_layer_value(1, true)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and CameraControlled:  
		var relative: Vector2 = event.relative  
		$Node3D.rotation_degrees.y -= rad_to_deg(relative.x / 200)
		$Node3D.rotation_degrees.x -= rad_to_deg(relative.y / 200)
		$Node3D.rotation_degrees.x = clamp($Node3D.rotation_degrees.x, -90, 90)
@onready var drag_ray: RayCast3D = $dragRay

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("leftClick") and not editing:
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * 256
		ray.global_position = from
		ray.target_position = to
		selected = ray.get_collider()
		print(str(ray.get_collider()))
		
		if selected == null: return
		
		for item in explorer.item_count:
			if explorer.get_item_text(item) == selected.name:
				explorer.select(item)
	
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
			var from = camera.project_ray_origin(event.position)
			var to = from + camera.project_ray_normal(event.position) * 256
			drag_ray.transform.origin = from
			drag_ray.target_position = to
			
			if ray.is_colliding() and selected != null:
				var rayPos = drag_ray.get_collision_point()
				var snappedPos = Vector3(floor(rayPos.x), (snapped(rayPos.y + selected.scale.y / 2, 0.5)), floor(rayPos.z))
				selected.global_position = snappedPos

func _on_insert_pressed() -> void:
	$Create.play()
	var newPart:StaticBody3D = load("res://content/places/basePart.tscn").instantiate()
	newPart.name = str("Part", workspace.get_child_count())
	newPart.set_meta("BrickColor", color.get_item_text(0))
	newPart.set_meta("CanCollide", true)
	newPart.scale = Vector3(4, 1, 4)
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
	if selected:
		selected.set_meta("BrickColor", new_text)
		selected.Changed.emit()

func editing_toggle(toggled:bool):
	editing = toggled

func cancollide_toggled(toggled_on: bool) -> void:
	if selected:
		selected.set_meta("CanCollide", toggled_on)
		selected.Changed.emit()

func opacity_submitted(new_text: String) -> void:
	if selected:
		selected.set_meta("Opacity", float(new_text))
		selected.Changed.emit()

func _on_clone_pressed() -> void:
	
	if selected == null:
		return
	
	clone_ray.global_position.x = selected.global_position.x
	clone_ray.global_position.z = selected.global_position.z
	await get_tree().create_timer(.1).timeout
	var collision = clone_ray.get_collision_point()
	
	var newPart = selected.duplicate()
	newPart.name = str(newPart.name.rstrip("0123456789"), workspace.get_child_count())
	workspace.add_child(newPart)
	selected = newPart
	if clone_ray.is_colliding():
		newPart.global_position = collision + Vector3(0, newPart.scale.y / 2, 0)
	
	$Clone.play()

@onready var file_dialog: FileDialog = $Control/Panel/Export/FileDialog

func _on_export() -> void:
	file_dialog.visible = true

func _on_import() -> void:
	$Control/Panel/Import/ImportDialog.visible = true

func file_exported(path: String) -> void:
	$IONExport.export_to_file(workspace, path)

func partname_changed(new_text: String) -> void:
	selected.name = new_text
	for item in explorer.get_selected_items():
		explorer.set_item_text(item, selected.name)

func brickcolor_selected(index: int) -> void:
	if selected:
		selected.set_meta("BrickColor", color.get_item_text(index))
		selected.Changed.emit()

func delete() -> void:
	if selected:
		$Destroy.play()
		selected.queue_free()

func instance_added(node: Node) -> void:
	var PartIcon = load("res://content/textures/editor/BasePart.png")
	
	explorer.add_item(node.name)
	node.add_to_group("Editable")
	for item in explorer.item_count:
		if explorer.get_item_text(item) == node.name:
			explorer.select(item)
			explorer.set_item_icon(item, PartIcon)
	
	node.connect("clicked", func():
		print("part clicked!")
		)

func instance_selected(index: int) -> void:
	var Instance = workspace.get_node(explorer.get_item_text(index))
	await get_tree().create_timer(.1).timeout
	selected = Instance

func instance_destroying(node: Node) -> void:
	for item in explorer.item_count:
		if explorer.get_item_text(item) == node.name:
			explorer.remove_item(item)

func import(path: String) -> void:
	var place = FileAccess.open(path, FileAccess.READ)
	while place.get_position() < place.get_length():
		var InstancePath = place.get_var()
		var packedInstance = load(InstancePath)
		var newInstance: Node3D = packedInstance.instantiate()
		newInstance.name = place.get_var()
		
		var instancePosition = Vector3(place.get_var(), place.get_var(), place.get_var())
		var instanceScale = Vector3(place.get_var(), place.get_var(), place.get_var())
		var instanceRot = Vector3(place.get_var(), place.get_var(), place.get_var())
		
		newInstance.position = instancePosition
		newInstance.scale = instanceScale
		newInstance.rotation = instanceRot
		
		newInstance.set_meta("BrickColor", str(place.get_var()))
		newInstance.set_meta("Opacity", str(place.get_var()))
		newInstance.set_meta("CanCollide", str(place.get_var()))
		
		workspace.add_child(newInstance)
	place.close()
