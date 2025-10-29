extends Node


func _enter_tree():
	const RUNTIME_SERVER = "GDAIRuntimeServer"
	if ClassDB.class_exists(RUNTIME_SERVER) and ClassDB.can_instantiate(RUNTIME_SERVER):
		var runtime_server = ClassDB.instantiate(RUNTIME_SERVER)
		add_child(runtime_server)
