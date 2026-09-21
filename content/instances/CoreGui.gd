## The container holding all core UI elements for gameplay.

@icon("res://content/textures/editor/Gui.png")
extends CanvasLayer
class_name CoreGui

var HUD:Control = load("res://content/instances/HUD.tscn").instantiate()

func _ready() -> void:
	layer = 5
	add_child(HUD)
