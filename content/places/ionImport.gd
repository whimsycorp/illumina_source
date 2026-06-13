extends Node

func loadPlace(path: String) -> void:
	var json = JSON.new()
	var place = FileAccess.open(path, FileAccess.READ)
	
	while place.get_position() < place.get_length():
		var InstancePath = place.get_var()
		print(str(InstancePath))
		var packedInstance = load(InstancePath)
		print(str(packedInstance))
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
		
		add_child(newInstance)
		print(str(newInstance, ", ", place.get_position()))
		
	place.close()


func _ready() -> void:
	var path
	if get_meta("FilePath") != "":
		path = get_meta("FilePath")
	else: path = "res://ilm_places/default.ilm"
	
	loadPlace(path)
