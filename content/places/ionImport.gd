extends Node

func _ion_loaded(path: String) -> void:
	var json = JSON.new()
	var place = FileAccess.open(path, FileAccess.READ_WRITE)
	
	while place.get_position() < place.get_length():
		var line = place.get_line()
		var rawData = place.get_as_text()
		var instanceData = json.parse(line, true)
		
		var dataCheck = json.parse(rawData)
		if dataCheck != OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", line, " at line ", json.get_error_line())
			continue
		
		print(json.parse_string(rawData))
		
		var newInstance:Node3D = load("res://content/places/basePart.tscn").instantiate()
		newInstance.set_meta("BrickColor", instanceData["BrickColor"])
		add_child(newInstance)
		
		newInstance.position = Vector3(instanceData["px"], instanceData["py"], instanceData["pz"])
		newInstance.transform.scaled(Vector3(instanceData["sx"], instanceData["sy"], instanceData["sz"]))
		
		
	place.close()
