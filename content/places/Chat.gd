extends Control
@onready var line_edit: LineEdit = $Panel/LineEdit
@onready var text_edit: TextEdit = $Panel/TextEdit

func _ready() -> void:
	multiplayer.multiplayer_peer = NetworkHandler.Peer

func _process(delta: float) -> void:
	text_edit.scroll_vertical = INF

func _on_chat_sent(new_text: String) -> void:
	rpc("newMessage", NetworkHandler.ClientName, new_text)
	NetworkHandler.playerChatted.emit(multiplayer.get_unique_id(), new_text)
	line_edit.text = ""

@rpc ("any_peer", "call_remote")
func newMessage(username, msg):
	text_edit.text += str(username, ": ", msg, "\n")

func _input(event: InputEvent) -> void:
	if event.is_action_released("chatFocus"):
		if !line_edit.is_editing():
			line_edit.edit()

func editing(toggled_on: bool) -> void:
	CaptureInput.InputCaptured = toggled_on
