#Quality tag:
	#0 - High
	#1 - Medium
	#2 - Low

extends Node
class_name LOD_MODULE

onready var parent = get_parent()
onready var camera = get_viewport().get_camera()
onready var meshs_nodes = []

export (bool) var enabled = true
export (bool) var update_camera = true
export (bool) var emit_signal = false

export (Array) var lod_distances = [10,20,50]

export (Dictionary) var meshs_paths = {
	"0":NodePath(),
	"1":NodePath(),
	"2":NodePath()
} 

var distance_to_camera : int = 0
var active_lod : int = 0
var old_lod : int = active_lod

func _ready() -> void:
	update_meshs()


func _physics_process(_delta: float) -> void:
	if !enabled:
		return
	if update_camera:
		camera = get_viewport().get_camera()
	
	distance_to_camera = parent.global_transform.origin.distance_to(camera.global_transform.origin)
	
	if distance_to_camera >= lod_distances[0] and distance_to_camera <= lod_distances[1]:
		active_lod = 1
	elif distance_to_camera >= lod_distances[1]:
		active_lod = 2
	else:
		active_lod = 0
	
	#Enable suitable lod
	if active_lod != old_lod:
		for lod in meshs_nodes:
			lod.hide()
		meshs_nodes[active_lod].show()
		#print("Change lod to: %s" %active_lod)
	
	old_lod = active_lod

func update_meshs() -> void:
	meshs_nodes.clear()
	for path in meshs_paths.values():
		meshs_nodes.push_back(get_node(path))
