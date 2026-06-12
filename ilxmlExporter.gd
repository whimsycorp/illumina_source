extends Node

func instantiate(Instance:Node3D):
	var BrickColor
	if Instance.has_meta("BrickColor"):
		BrickColor = Instance.get_meta("BrickColor")
	else: BrickColor = "White"
	
	var dict = {
		"ClassName": Instance.scene_file_path,
		"Name": Instance.name,
		"px": Instance.position.x,
		"py": Instance.position.y,
		"pz": Instance.position.z,
		"sx": Instance.scale.x,
		"sy": Instance.scale.y,
		"sz": Instance.scale.z,
		"BrickColor": BrickColor
	}
	return dict

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_file_dialog_file_selected(path: String) -> void:
	var RawScene = load(path)
	var InstantiatedScene = RawScene.instantiate()
	
	var fileName = path.get_file().trim_suffix("." + path.get_extension())
	print(fileName)
	
	var exportedScene = FileAccess.open("res://exports/" + fileName + ".ion", FileAccess.WRITE)
	
	var sceneNodes = InstantiatedScene.get_children()
	for node in sceneNodes:
		var node_data = instantiate(node)
		var json = JSON.new()
		var json_string = json.stringify(node_data)
		exportedScene.store_line(json_string)
	
	print("Exported to file " + "res://exports/" + fileName + ".ion")
	exportedScene.close()
