## Handles all Player objects.

@icon("res://content/textures/editor/Players.png")
extends Node
class_name Players

func NewClient() -> Player:  ## Creates a new Player instance and returns it if needed.
	var NewPlayer = Player.new()
	add_child(NewPlayer)
	return NewPlayer

func GetPlayerFromModel(character:Model):
	for plr:Player in get_children():
		if plr.Character == character:
			return plr

func init():
	ServiceManager.LocalPlayers = self
