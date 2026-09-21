## A type of BasePart that character models can sit in.
##
## Upon sitting in a Seat, the Humanoid will be welded to the part until exited.

@icon("res://content/textures/editor/Seat.png")
extends BasePart
class_name Seat

var SeatWeld = Generic6DOFJoint3D.new()
@export var Occupant:Humanoid

func Sit(humanoid:Humanoid): ## Forces a Humanoid into the Seat.
	var PlayerModel:Model = humanoid.get_parent() # get player model
	PlayerModel.global_position = global_position + Vector3(0, PlayerModel.RootPart.Size.y / 2, 0) # move player model to seat
	
	# weld player to the seat
	SeatWeld.node_b = PlayerModel.RootPart
	
	 # set occupant to humanoid
	Occupant = humanoid
	
	 # wait for the player to jump, then release them from the seat
	await humanoid.Jumping
	if Occupant == humanoid:
		ReleasePlayer()

func ReleasePlayer():
	var Player = Occupant
	Occupant = null
	SeatWeld.node_b = null

func OnTouch(body: Node) -> void:
	if body is BasePart and not Occupant:
		var Parent = body.get_parent()
		var humanoid = body.FindFirstChildOfClass("Humanoid")
		if humanoid:
			Sit(humanoid)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_queued_for_deletion() and Occupant != null:
		ReleasePlayer()
