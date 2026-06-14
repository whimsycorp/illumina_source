extends Node

func export_to_file(fileName: String, srcNode:Node) -> void:
	var exportedScene = FileAccess.open("res://ilm_places/" + fileName + ".ilm", FileAccess.WRITE)
	var sceneNodes = srcNode.get_children()
	for node in sceneNodes:
		if node == null:
			return
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
