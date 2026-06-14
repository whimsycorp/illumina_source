extends MultiplayerSpawner

var Args = OS.get_cmdline_args()

func _ready() -> void:
	NetworkHandler.ServerCreated.connect(loadPlace)

func loadPlace():
	var arguments = {}
	
	for arg in Args:
		if arg.find("=") > -1:
			var keyval = arg.split("=")
			arguments[keyval[0].lstrip("--")] = keyval[1]
	
	if multiplayer.is_server():
		var placeLoader = load("res://IONImport.tscn")
		var Loader:Node = placeLoader.instantiate()
		if arguments.has("place"):
			Loader.set_meta("FilePath", arguments["place"])
		get_node(spawn_path).add_child(Loader)
