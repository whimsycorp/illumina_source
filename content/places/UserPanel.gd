extends Panel
@onready var user_id: Label = $UserID
@onready var player_name: Label = $PlayerName


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player_name.text = str(NetworkHandler.ClientName)
	user_id.text = str("<UniqueID:", NetworkHandler.UniqueID, ">")
