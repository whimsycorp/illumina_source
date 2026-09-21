## Used for giving Parts more precise shapes.
##
## Has no methods of its own.

extends Node
class_name SpecialMesh

enum Type {
	Head, ## Default head mesh used for Humanoids.
	Block, ## Default block mesh for BaseParts.
	File ## Wildcard type for use with TextureId and MeshId.
}
@export var MeshType:Type = Type.Head ## Defines the shape of the mesh's Parent.
@export var TextureId:int = 000000 ## Defines what texture to wrap around the mesh, if any.
@export var MeshId:int = 000000 ## Defines what mesh the part will take when used with the File MeshType.
