extends Node3D

var mouse_sense = 0.25
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.pause_game = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
		if event is InputEventMouseMotion:
			$Camera3D.rotation_degrees.y -= deg_to_rad(event.relative.x * mouse_sense)
			$Camera3D.rotation_degrees.x -= deg_to_rad(event.relative.y * mouse_sense)
			$Camera3D.rotation.x = clamp($Camera3D.rotation.x, deg_to_rad(-5), deg_to_rad(5))
			$Camera3D.rotation.y = clamp($Camera3D.rotation.y, deg_to_rad(-5), deg_to_rad(5))

func _on_start_button_pressed():
	$AudioStreamPlayer.stream = load("res://assets/sound/doors/doorOpen.ogg")
	$AudioStreamPlayer.pitch_scale = 1.0
	$AudioStreamPlayer.play()
	
	await get_tree().create_timer(0.7).timeout 
	get_tree().change_scene_to_file("res://start_menu/loading.tscn")


func _on_exit_button_pressed():
	get_tree().quit()


func _on_fullscreen_button_pressed():
	if DisplayServer.window_get_mode() == 0:
		DisplayServer.window_set_mode(3)
	else:
		DisplayServer.window_set_mode(0)
