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
	print("test")
	Global.pause_game = false
	game_scene.pause_game = false
