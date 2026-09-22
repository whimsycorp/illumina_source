## A special object that allows models to function as a character.

@icon("res://content/textures/editor/Humanoid.png")
extends Node
class_name Humanoid

@export var RootPart:BasePart ## A part that acts as the Humanoid's root. Humanoids die upon having their RootPart deleted.
@export var CameraSubject:BasePart ## A part that the camera will pivot around.

@export var MaxHealth:float = 100 ## The maximum health value of the Humanoid.
@export var Health:float = 100 ## The current health value of the Humanoid.
@export var WalkSpeed:float = 16 ## The maximum speed the Humanoid will move by in studs.
@export var JumpPower:float = 50 ## How much force will be applied to the Humanoid when jumping

@export var HipHeight:float = 2 ## The height at which the humanoid's RootPart will float above the ground.

enum HumanoidStateType {
	IDLE, ## A neutral state for when the player is not moving.
	RUNNING, ## Currently running while on the ground.
	JUMPING, ## The player is mid-air and moving upwards. 
	FREEFALL, ## The player is mid-air and moving downwards.
	RAGDOLL, ## The player is rendered unable to move, for any reason.
	SEATED, ## The player is sitting in a Seat.
	DEAD ## The player has died.
}

var HumanoidState:HumanoidStateType = HumanoidStateType.IDLE

signal Running ## Fires when the speed the player is moving at changes. Fires with a value of zero when the player stops moving.
signal Jumping ## Fires when the player jumps.
signal Freefall ## Fires when the player is mid-air and moving downwards, either after a jump or walking off a ledge.
signal Ragdoll ## Fires when the player is unable to move for any reason.
signal Died ## Fires when the player dies. Obviously.
signal Hurt ## Fires when the player's health value lowers.

var JumpSound = Sound.new("res://content/sounds/swoosh.wav")
var PlayerCam = PlayerCamera.new()

var FloatRay = RayCast3D.new()

func TakeDamage(amount:float):
	Health = clampf(Health - amount, 0, MaxHealth)
	if Health == 0:
		Kill()

func Kill():
	HumanoidState = HumanoidStateType.DEAD
	var PlayerModel:Model = get_parent()
	PlayerModel.Break()

func Jump():
	JumpSound.Play()
	RootPart.apply_central_impulse(Vector3.UP * (JumpPower * 40))
	Jumping.emit()

func Move(vector:Vector3):
	RootPart.add_constant_central_force(vector * WalkSpeed * 50)

func _ready() -> void:
	add_child(JumpSound)
	RootPart.add_child.call_deferred(FloatRay)
	FloatRay.position.y = -1
	FloatRay.target_position = Vector3.DOWN * (HipHeight)
	for v in get_parent().get_children():
		if v is CollisionObject3D:
			FloatRay.add_exception(v)

var PreviousLength = 0.0

func _physics_process(delta: float) -> void:
	
	if FloatRay.is_colliding(): # if on the ground
		# attempt to float RootPart at HipHeight
		
		var Distance = FloatRay.get_collision_point().distance_to(FloatRay.global_position)
		const FloatStrength = 50000
		const FloatDamper = 1000
		
		var CurrentLength = clamp(Distance, 0, HipHeight)
		
		# var DamperForce = ((CurrentDistance - LastDistance) * DistMultiplier / delta) * DamperBounce
		var SpringForce = (FloatStrength * (HipHeight - CurrentLength))
		var SpringVelocity = (PreviousLength - CurrentLength) / delta
		
		var DamperForce = FloatDamper * SpringVelocity
		
		var FloatingForce = RootPart.basis.y * (SpringForce + DamperForce)
		PreviousLength = CurrentLength
		
		RootPart.apply_central_force(RootPart.global_basis.y * FloatingForce)
		
		# allow jumping
		if Input.is_action_just_pressed("Jump"):
			Jump()
		
	var direction = Vector3(Input.get_axis("back", "forward"), 0, Input.get_axis("strafeLeft", "strafeRight"))
	if direction:
		RootPart.linear_velocity.x = direction.x * WalkSpeed
		RootPart.linear_velocity.z = direction.z * WalkSpeed
	else:
		RootPart.constant_force = Vector3.ZERO
		RootPart.linear_velocity.x = 0
		RootPart.linear_velocity.z = 0
	
