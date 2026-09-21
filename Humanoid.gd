## A special object that allows models to function as a character.

@icon("res://content/textures/editor/Humanoid.png")
extends Node
class_name Humanoid


@export var RootPart:BasePart ## A part that acts as the Humanoid's root. Humanoids die upon having their RootPart deleted.

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

func TakeDamage(amount:float):
	amount = clampf(amount, 0, MaxHealth)
	Health -= amount
	Hurt.emit()

func Jump():
	RootPart.apply_central_impulse(Vector3.UP * (JumpPower * 10))
	Jumping.emit()
