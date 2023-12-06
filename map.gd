extends Node3D

signal pause(paused : bool)

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	

@onready var pause_game = Global.pause_game:
	get:
		return Global.pause_game
	set(value):
		pause_game = value
		get_tree().paused = pause_game
		if pause_game:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		emit_signal("pause", pause_game)


func _process(delta):
	if Input.is_action_just_released("pause"):
		Global.pause_game =! Global.pause_game
		pause_game = Global.pause_game
		
