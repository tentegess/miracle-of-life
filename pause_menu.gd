extends Control

@export var game_scene : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	game_scene.connect("pause", show_menu)

func show_menu(is_paused):
	if is_paused && Global.pause_game:
		show()
	else:
		hide()	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	Global.pause_game = false
	game_scene.pause_game = false


func _on_fullscreen_button_pressed():
	if DisplayServer.window_get_mode() == 0:
		DisplayServer.window_set_mode(3)
	else:
		DisplayServer.window_set_mode(0)


func _on_exit_button_button_down():
	game_scene.pause_game = false
	get_tree().change_scene_to_file("res://start_menu/menu.tscn")
