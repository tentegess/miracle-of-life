extends Node


var loading = false
var scene_to_load = "res://map.tscn"

func _ready():
	get_tree().paused = false
	Global.pause_game = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	ResourceLoader.load_threaded_request(scene_to_load)


	
func _process(delta):
		
	var progress = []
	var status = ResourceLoader.load_threaded_get_status(scene_to_load, progress)
	
	if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		$ProgressBar.value = progress[0] * 100
	elif status == ResourceLoader.THREAD_LOAD_LOADED:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(scene_to_load))
		queue_free()
		
	
