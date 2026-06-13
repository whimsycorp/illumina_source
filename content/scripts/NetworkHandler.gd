extends Node

const SERVER_IP: String = "localhost"
const PORT: int = 1337
const MAX_PLAYERS = 16

var Peer = NodeTunnelPeer.new()
@export var PlayerNames = {}

func _ready() -> void:
	multiplayer.multiplayer_peer = Peer
	Peer.connect_to_relay("relay.nodetunnel.io", 9998)
	
	await Peer.relay_connected

func newServer() -> void:
	Peer.host()
	await Peer.hosting
	
	DisplayServer.clipboard_set(str(Peer.online_id))
	print(str(Peer.online_id))
	
	Peer.peer_connected.connect(
		func(pid):
			print("Player " + str(pid) + " has joined the server!")
	)

@export var ClientName: String
@export var UniqueID: String

func newClient(hostID:String, username:String) -> void:
	Peer.join(hostID)
	await Peer.joined
	var PlayerName
	var id = multiplayer.get_unique_id()
	if username:
		PlayerName = username
	else: PlayerName = str("Guest", multiplayer.get_unique_id())
	PlayerNames[id] = PlayerName
	ClientName = PlayerName
	UniqueID = str(multiplayer.get_unique_id()).sha256_text()
