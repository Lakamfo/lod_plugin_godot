tool
extends EditorPlugin

var lods : Array = []
var bt = preload("res://addons/golod_plugin/update_bt.tscn").instance()

func _enter_tree() -> void:
	if connect("scene_changed",self,"get_lods"):pass
	if get_tree().connect("node_added",self,"_handle_nodes"):pass
	
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU,bt)
	add_custom_type("LOD","Node",load("res://addons/golod_plugin/LOD_MODULE_SCRIPT.gd"),load("res://addons/golod_plugin/icon.png"))
	
	bt.connect("pressed",self,"get_lods",[0])

func _handle_nodes(node) -> void:
	if node.has_signal("lod_changed"):
		get_lods(node)

func get_lods(scene) -> void:
	var camera = get_editor_interface().get_editor_viewport().get_child(1).get_child(1).get_child(0).get_child(0).get_child(0).get_child(0).get_child(0).get_camera()
	lods = get_tree().get_nodes_in_group("LOD")
	
	for lod in lods:
		lod.camera = camera
		lod.is_editor = true

func _exit_tree() -> void:
	bt.queue_free()
	remove_custom_type("LOD")
