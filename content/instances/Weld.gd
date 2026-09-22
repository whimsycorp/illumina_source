## Binds physics objects together in the world.

@icon("res://content/textures/editor/Weld.png")
extends HingeJoint3D
class_name Binding

@export var Part0:NodePath ## The part to connect Part1 to.
@export var Part1:NodePath ## The part to be connected to Part0.
@export var Enabled:bool = true ## Whether or not the joint will restrict part movement.

func _init() -> void:
	set("angular_limit/enable", true)
	set("angular_limit/upper", 0.0)
	set("angular_limit/upper", 0.0)
	set("angular_limit/bias", 0.99)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Enabled:
		node_a = Part0
		node_b = Part1
