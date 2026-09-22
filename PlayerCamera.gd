## A camera that the player's viewport will see from.

@icon("res://content/textures/editor/Camera.png")
extends Node3D
class_name PlayerCamera

@export var FOV:float = 90
@export var Distance:float = 12
var Camera = Camera3D.new()

func _init() -> void:
	add_child(Camera)

func _process(_delta) -> void:
	Camera.position = Vector3(0, Distance / (2/3), Distance)
