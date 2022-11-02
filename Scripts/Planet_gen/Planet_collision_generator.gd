extends Spatial

#get variables for each mesh
onready var front_mesh = $"Meshes/Front"
onready var back_mesh = $"Meshes/Back"
onready var up_mesh = $"Meshes/Up"
onready var down_mesh = $"Meshes/Down"
onready var left_mesh = $"Meshes/Left"
onready var right_mesh = $"Meshes/Right"

var meshes = []

func _ready():
	Globals.planet = self
	
	meshes.append(front_mesh)
	meshes.append(back_mesh)
	meshes.append(up_mesh)
	meshes.append(down_mesh)
	meshes.append(left_mesh)
	meshes.append(right_mesh)
	
	#generate the collision shape for each mesh
	for i in meshes:
		i.create_trimesh_collision()
