@icon("res://content/textures/editor/Weld.png")
extends Node3D
class_name JointInstance

@export var Part0:NodePath ## The part to connect Part1 to.
@export var Part1:NodePath ## The part to be connected to Part0.
@export var Enabled:bool = true ## Whether or not the joint will restrict part movement.

var Joint = Generic6DOFJoint3D.new()

enum Type {
	Weld, ## Connects two parts together with no independent movement.
	Hinge, ## Connects two parts together, allowing one axis of angular movement.
	Slide, ## Connects two parts together, allowing one axis of linear movement.
	Motor3D, ## Connects two parts together with 6 degrees of angular freedom.
	Motor6D, ## Connects two parts together with 6 degrees of freedom. By itself, doesn't constraint the part's movement at all.
}

enum Axis {
	X, ## The joint will only allow movement on the X axis.
	Y, ## The joint will only allow movement on the Y axis.
	Z, ## The joint will only allow movement on the Z axis.
}

@export var JointType:Type = Type.Weld ## The type of constraint that the Joint will behave like.
@export var JointAxis:Axis ## The axis which Hinge and Slide joints will move along.
@export var UpperJointMovementBound:Vector3 = Vector3.ONE * 90 ## The upper limit of how far the joint can move on each axis.
@export var LowerJointMovementBound:Vector3 = Vector3.ONE * -90 ## The lower limit of how far the joint can move on each axis.

func _ready() -> void:
	add_child(Joint)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Enabled:
		Joint.node_a = Part0
		Joint.node_b = Part1
		
		Joint.set("linear_limit_x/enabled", true)
		Joint.set("linear_limit_y/enabled", true)
		Joint.set("linear_limit_z/enabled", true)
		Joint.set("angular_limit_x/enabled", true)
		Joint.set("angular_limit_y/enabled", true)
		Joint.set("angular_limit_z/enabled", true)
		Joint.set("angular_limit_x/upper_angle", 0.0)
		Joint.set("angular_limit_x/lower_angle", 0.0)
		Joint.set("angular_limit_y/upper_angle", 0.0)
		Joint.set("angular_limit_y/lower_angle", 0.0)
		Joint.set("angular_limit_z/upper_angle", 0.0)
		Joint.set("angular_limit_z/lower_angle", 0.0)
		
		
		match JointType:
			Type.Weld:
				pass
			Type.Hinge:
				match JointAxis:
					Axis.X:
						Joint.set("angular_limit_x/upper_angle", UpperJointMovementBound.x)
						Joint.set("angular_limit_x/lower_angle", LowerJointMovementBound.x)
					Axis.Y:
						Joint.set("angular_limit_y/upper_angle", UpperJointMovementBound.y)
						Joint.set("angular_limit_y/lower_angle", LowerJointMovementBound.y)
					Axis.Z:
						Joint.set("angular_limit_z/upper_angle", UpperJointMovementBound.z)
						Joint.set("angular_limit_z/lower_angle", LowerJointMovementBound.z)
			Type.Slide:
				match JointAxis:
					Axis.X:
						Joint.set("linear_limit_x/upper_distance", UpperJointMovementBound.x)
						Joint.set("linear_limit_x/lower_distance", LowerJointMovementBound.x)
					Axis.Y:
						Joint.set("linear_limit_y/upper_distance", UpperJointMovementBound.y)
						Joint.set("linear_limit_y/lower_distance", LowerJointMovementBound.y)
					Axis.Z:
						Joint.set("linear_limit_x/upper_distance", UpperJointMovementBound.z)
						Joint.set("linear_limit_z/lower_distance", LowerJointMovementBound.z)
			Type.Motor3D:
				Joint.set("linear_limit_x/upper_distance", UpperJointMovementBound.x)
				Joint.set("linear_limit_x/lower_distance", LowerJointMovementBound.x)
				Joint.set("linear_limit_y/upper_distance", UpperJointMovementBound.y)
				Joint.set("linear_limit_y/lower_distance", LowerJointMovementBound.y)
				Joint.set("linear_limit_x/upper_distance", UpperJointMovementBound.z)
				Joint.set("linear_limit_z/lower_distance", LowerJointMovementBound.z)
