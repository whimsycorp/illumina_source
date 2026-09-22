## A base class meant for global audio playback.

@icon("res://content/textures/editor/Sound.png")
extends AudioStreamPlayer
class_name Sound

func _init(soundfile:String):
	var audio = load(soundfile)
	stream = audio

func Play(DeleteUponEnd:bool = false):
	play()
	
	if DeleteUponEnd:
		await finished
		queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
