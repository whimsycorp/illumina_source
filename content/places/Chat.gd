extends Control
@onready var line_edit: LineEdit = $Panel/LineEdit
@onready var text_edit: TextEdit = $Panel/TextEdit

func _on_chat_sent(new_text: String) -> void:
	rpc("newMessage", NetworkHandler.ClientName, new_text)
	line_edit.text = ""

@rpc ("any_peer", "call_remote")
func newMessage(username, msg):
	text_edit.text += str(username, ": ", msg, "\n")
	text_edit.scroll_vertical = INF


func editing(toggled_on: bool) -> void:
	CaptureInput.InputCaptured = toggled_on
