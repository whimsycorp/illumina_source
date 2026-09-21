## An object representing a connected client.

@icon("res://content/textures/editor/Humanoid.png")
extends Node
class_name Player

# ingame variables

@export var Character:Model ## The character model the player is currently controlling.

# online-related variables

enum ClientType {
	Visitor,
	Basic,
	Contributor,
	EclipseMember,
}

@export var IsVisiting:bool ## Determines whether or not the player is a Visitor account or not.
@export var UserId: float ## The UserId of the player's online account.
@export var AccountType:ClientType = ClientType.Visitor

func LoadCharacter(parent:Node):
	var NewCharacter:Model = load("res://content/places/Character.scn").instantiate()
	var SpawnBass = Sound.new("res://content/sounds/bass.wav")
	
	if Character:
		Character.queue_free()
	Character = NewCharacter
	parent.add_child(Character)
	add_child(SpawnBass)
	SpawnBass.Play(true)
