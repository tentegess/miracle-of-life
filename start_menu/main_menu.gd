extends Node3D

@onready var input_settings = $input_settings
@onready var action_list = $input_settings/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer
@onready var input_button_scene = preload("res://start_menu/input_button.tscn")

var is_remapping = false
var action_to_remap = null
var remapping_button = null
var input_actions = {
		"move_forward": "Idź do przodu",
		"move_right": "Idź w prawo",
		"move_left": "Idź w lewo",
		"move_back": "Idź do tyłu",
	}

var mouse_sense = 0.07
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
			
		if is_remapping:
			if (
				event is InputEventKey or 
				(event is InputEventMouseButton and event.pressed)
			):
				if event is InputEventMouseButton and event.double_click:
					event.double_click = false
					
				
				InputMap.action_erase_events(action_to_remap)
				InputMap.action_add_event(action_to_remap, event)
				_update_action_list(remapping_button, event)
				
				is_remapping = false
				action_to_remap = null
				remapping_button = null
				
				input_settings.accept_event()


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


func _on_control_button_pressed():
	$menu.visible = false
	input_settings.visible = true
	InputMap.load_from_project_settings()
	for item in action_list.get_children():
		item.queue_free()
		
	for action in input_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("label_action")
		var input_label = button.find_child('label_input')
		action_label.text = input_actions[action]
		var events = InputMap.action_get_events(action)
		print(events[0])
		if events.size() > 0:
			input_label.text = events[0].as_text()
		else:
			input_label.text = ""
			
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))
		
		
func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child('label_input').text = "Naciśnij przycisk, aby przypisać..."
			
			
func _update_action_list(button, event):
	button.find_child("label_input").text = event.as_text()
			
			
func _on_save_button_pressed():
	$menu.visible = true
	input_settings.visible = false
	
	var index = 0
	for action in action_list.get_children():
		var action_name = input_actions.keys()[index]
		var action_event_str  = action.find_child("label_input").text
		var action_event = InputEventKey.new()
		#action_event.scancode = OS.find_scancode_from_string(action_event_str)
		#InputMap.action_add_event(action_name, action_event)
		index += 1
		


