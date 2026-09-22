## The root of the game hierarchy, and parent of most services like Workspace or Lighting.

@icon("res://content/textures/editor/Containers.png")
extends Node
class_name DataModel

@export var CreatorId:int ## The UserId of the creator of the current loaded game.
@export var PlaceId:int ## The PlaceId of the current loaded game.
@export var JobId:int ## The identifier for the running server instance.

var workspace = Workspace.new()
var lighting = Lighting.new()
var players = Players.new()
var rservice = ReplicationService.new()
var coreGui = CoreGui.new()

func _ready() -> void:
	
	add_child(workspace)
	add_child(lighting)
	add_child(players)
	add_child(rservice)
	add_child(coreGui)
	
	var TestPlayer = players.NewClient()
	TestPlayer.LoadCharacter(workspace)
