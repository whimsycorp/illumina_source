extends Node

func _on_file_dialog_file_selected(path: String) -> void:
	var RawScene = load(path)
	var InstantiatedScene = RawScene.instantiate()
	
	var fileName = path.get_file().trim_suffix("." + path.get_extension())
	print(fileName)
	
	var exportedScene = FileAccess.open("res://ilm_places/" + fileName + ".ilm", FileAccess.WRITE)
	var sceneNodes = InstantiatedScene.get_children()
	for node:Node3D in sceneNodes:
		# instance resource
		exportedScene.store_var(node.scene_file_path)
		
		# instance name
		exportedScene.store_var(node.name)
		
		# instance position
		exportedScene.store_var(node.position.x)
		exportedScene.store_var(node.position.y)
		exportedScene.store_var(node.position.z)
		
		# instance size
		exportedScene.store_var(node.scale.x)
		exportedScene.store_var(node.scale.y)
		exportedScene.store_var(node.scale.z)
		
		# instance rotation
		exportedScene.store_var(node.rotation.x)
		exportedScene.store_var(node.rotation.y)
		exportedScene.store_var(node.rotation.z)
		
		# instance BrickColor value
		exportedScene.store_var(str(node.get_meta("BrickColor")))
		exportedScene.store_var(str(node.get_meta("Opacity")))
		exportedScene.store_var(str(node.get_meta("CanCollide")))
		
		
	print("Exported to file " + "res://exports/" + fileName + ".ilm")
	exportedScene.close()
