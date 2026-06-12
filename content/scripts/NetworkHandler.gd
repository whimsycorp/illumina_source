extends Node

const SERVER_IP: String = "localhost"
const PORT: int = 1337
const MAX_PLAYERS = 16

var Peer = NodeTunnelPeer.new()

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

func newClient(hostID:String) -> void:
	
	Peer.join(hostID)
	
	await Peer.joined
