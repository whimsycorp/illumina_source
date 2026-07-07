extends Node

const SERVER_IP: String = "localhost"
const PORT: int = 1337
const MAX_PLAYERS = 16

var Peer = NodeTunnelPeer.new()
@export var PlayerNames = {}
@export var Character: CharacterBody3D
signal playerChatted(id, msg)
signal ServerCreated
var arguments = OS.get_cmdline_args()
var rawWebArgs: String
var PlaceURL: String

func _ready() -> void:
	var args = Array(arguments)
	rawWebArgs = args[0].trim_prefix("illumina://")
	
	multiplayer.multiplayer_peer = Peer
	Peer.connect_to_relay("us_east.nodetunnel.io", 9998)
	await Peer.relay_connected
	# formatting
	
	if args.has("-server"):
		print("Starting game as server..")
		newServer()

var HTTP = HTTPRequest.new()

func newServer() -> void:
	Peer.host()
	await Peer.hosting
	ServerCreated.emit()
	
	DisplayServer.clipboard_set(str(Peer.online_id))
	print(str("Current Server ID: ", Peer.online_id))
	
	Peer.peer_connected.connect(
		func(pid):
			print("Player " + str(pid - 1) + " has joined the server!"))
	var json = JSON.stringify({"active" = true, "serverID" = Peer.online_id})
	print(str(json))
	var url = "https://junipers.cc/servers"
	var headers = ["Content-Type: application/json"]
	add_child(HTTP)
	HTTP.request_completed.connect(requested)
	var request = HTTP.request(url, headers, HTTPClient.METHOD_POST, json)
	if request != OK:
		print("http error")

@export var ClientName: String
@export var UniqueID: String

func requested(result, response_code, headers, body):
	var requestJSON = JSON.new()
	var parsed = requestJSON.parse(body.get_string_from_utf8())
	if parsed != OK:
		print(str("couldnt parse"))

func newClient(hostID:String, username:String) -> void:
	Peer.join(hostID)
	await Peer.joined
	print("joined")
	var PlayerName
	var id = multiplayer.get_unique_id()
	if username:
		PlayerName = username
	else: PlayerName = str("Guest", multiplayer.get_unique_id())
	print("username: " + PlayerName)
	PlayerNames[id] = PlayerName
	ClientName = PlayerName
	UniqueID = str(id)
