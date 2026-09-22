## The global lighting controller. Houses the skybox.

@icon("res://content/textures/editor/Light.png")
extends Node
class_name Lighting

var Skybox = load("res://content/places/Skybox.scn").instantiate()

func _ready() -> void:
	add_child(Skybox)
	ServiceManager.LocalLighting = self
