extends MultiplayerSpawner

@export var networkPlayer: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(NewPlayer)

func NewPlayer(id:int) -> void:
	if !multiplayer.is_server(): return
	
	var CurrentPlayer: Node = networkPlayer.instantiate()
	CurrentPlayer.name = "Player" + str(id)
	
	get_node(spawn_path).call_deferred("add_child", CurrentPlayer)
	CurrentPlayer.position = Vector3(0, 50, 0)
	NetworkHandler.Character = CurrentPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
