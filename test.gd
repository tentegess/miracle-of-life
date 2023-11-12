extends Node3D

var pause_game = false

signal pause
signal unpause

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("pause"):
		pause_game=!pause_game
		if pause_game:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Engine.time_scale = 0
			pause.emit()
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Engine.time_scale = 1
			unpause.emit()
