extends Control
var toggled = false

@onready var username: LineEdit = $Network/Username
@onready var address: LineEdit = $Network/Address

func _on_server_pressed() -> void:
	NetworkHandler.newServer()
	$MenuButton.button_pressed = false

var playerName: String

func _on_client_pressed() -> void:
	if $Network/Address.text != "":
		NetworkHandler.newClient(address.text, username.text)
		$MenuButton.button_pressed = false
		$ChatButton.button_pressed = true
	else: print("no server id entered!")


func _on_menu_button_toggled(toggled_on: bool) -> void:
	$Network.visible = toggled_on


func _on_chat_button_toggled(toggled_on: bool) -> void:
	$Chat.visible = toggled_on
