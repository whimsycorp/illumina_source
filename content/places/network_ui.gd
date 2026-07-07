extends Control
var toggled = false

@onready var username: LineEdit = $Network/Username
@onready var address: LineEdit = $Network/Address

func _ready() -> void:
	$ChatButton.visible = false
	var args = Array(OS.get_cmdline_args())
	$Chat/Panel/TextEdit.text += str(NetworkHandler.arguments, "\n")
	$Chat/Panel/TextEdit.text += str(NetworkHandler.rawWebArgs, "\n")
	
	var webArgs = NetworkHandler.rawWebArgs
	var ID = ""
	
	await NetworkHandler.Peer.relay_connected
	
	if webArgs.contains("play"):
		ID = webArgs.trim_prefix("play")
		ID = ID.lstrip("/?")
		$Chat/Panel/TextEdit.text += str(ID, "\n")
		if ID.begins_with("id="):
			ID = ID.substr(3, 8)
			await get_tree().create_timer(2).timeout
			_on_client_pressed(ID)

func _on_server_pressed() -> void:
	NetworkHandler.newServer()
	$MenuButton.button_pressed = false

var playerName: String

func _on_client_pressed(serverID: String = address.text) -> void:
	if serverID != "":
		NetworkHandler.newClient(serverID, username.text)
		$Network.visible = false
		$ChatButton.visible = true
	else: print("no server id entered!")


func _on_menu_button_toggled(toggled_on: bool) -> void:
	$Network.visible = !$Network.visible


func _on_chat_button_toggled(toggled_on: bool) -> void:
	$Chat.visible = !$Chat.visible
