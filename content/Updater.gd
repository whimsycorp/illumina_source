extends Control

@onready var updater: HTTPRequest = $UpdateRetriever

func update(link, path):
	updater.connect("request_completed", _on_request_completed)
	


func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	pass # Replace with function body.
