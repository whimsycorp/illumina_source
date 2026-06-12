extends Control



func _on_server_pressed() -> void:
	NetworkHandler.newServer()

func _on_client_pressed() -> void:
	if $Network/Address.text != "":
		NetworkHandler.newClient($Network/Address.text)
	else: NetworkHandler.newClient("localhost")


func _on_menu_button_toggled(toggled_on: bool) -> void:
	$Network.visible = toggled_on


func _on_chat_button_toggled(toggled_on: bool) -> void:
	$Chat.visible = toggled_on
