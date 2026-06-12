extends Control
var toggled = false

func _on_server_pressed() -> void:
	NetworkHandler.newServer()
	$MenuButton.button_pressed = false

func _on_client_pressed() -> void:
	if $Network/Address.text != "":
		NetworkHandler.newClient($Network/Address.text)
	else: NetworkHandler.newClient("localhost")
	
	$MenuButton.button_pressed = false


func _on_menu_button_toggled(toggled_on: bool) -> void:
	$Network.visible = toggled_on


func _on_chat_button_toggled(toggled_on: bool) -> void:
	$Chat.visible = toggled_on
