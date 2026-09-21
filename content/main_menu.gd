extends Node2D

enum Screen {
	Title,
	SignUp,
	Home,
	Avatar,
	Games,
	Create
}

var CurrentPage = Screen.Title

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		
		if CurrentPage == Screen.Title:
			CurrentPage = Screen.SignUp
			$Focus/AnimationPlayer.play("signup_transition")
			$Confirm.play()
