## Models are container objects that group instances together. They are best used to hold collections of BaseParts.
##
##

@icon("res://content/textures/editor/Model.png")
extends Node3D
class_name Model

@export var RootPart:BasePart ## The part that the model will pivot around.
@export var Scale:float = 1.0 ## The scale of the Model.

func _ready() -> void:
	if RootPart:
		global_position = RootPart.global_position
		RootPart.position = Vector3.ZERO

func BreakJoints():
	for v in get_children():
		if v is Joint3D:
			v.queue_free()

func TranslateBy(delta:Vector3):
	global_position += delta
