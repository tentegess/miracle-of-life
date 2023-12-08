extends Node

@onready var input_settings = self
@onready var action_list = $PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer
@onready var input_button_scene = preload("res://start_menu/input_button.tscn")

var is_remapping = false
var action_to_remap = null
var remapping_button = null
var is_valid = true
var input_actions = {
		"move_forward": "Idź do przodu",
		"move_right": "Idź w prawo",
		"move_left": "Idź w lewo",
		"move_back": "Idź do tyłu",
		"jump": "Skok",
		"crouch": "Kucanie",
		"run": "Bieganie",
		"left_click": "Podnoszenie przedmiotów",
		"right_click": "Obracanie przedmiotów",
		"pause": "Pauza",
	}
var input_changed = {}


func _input(event):
		if is_remapping:
			if (
				(event is InputEventKey or 
				event is InputEventMouseButton) and event.pressed and !event.is_echo()
			):
				if event is InputEventMouseButton and event.double_click:
					event.double_click = false
				_update_action_list(remapping_button, event)
				is_remapping = false
				var temp_button = remapping_button
				remapping_button = null
				
				input_settings.accept_event()
				
				
				var new_value = event.as_text().trim_suffix(" (Physical)")
				for item in action_list.get_children():
					if item.find_child('label_input').text == new_value and item != temp_button:
						is_remapping = false
						_on_input_button_pressed(item)


func _on_control_button_pressed():
	input_changed = Global.old_input_changed
	$"../menu".visible = false
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
		if input_changed.has(action):
			input_label.text = input_changed[action].as_text().trim_suffix(" (Physical)")
		elif events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
			
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button))
		
		
func _on_input_button_pressed(button):
	if !is_remapping:
		is_remapping = true
		remapping_button = button
		button.find_child('label_input').text = "Naciśnij przycisk..."
			
			
func _update_action_list(button, event):
	var action_name = button.find_child("label_action").text
	button.find_child("label_input").text = event.as_text().trim_suffix(" (Physical)")
	for key in input_actions:
		if input_actions[key] == action_name:
			input_changed[key] = event
			
			
func _on_save_button_pressed():
	for key in input_changed.keys():
		print(input_changed[key])
		InputMap.action_erase_events(key)
		InputMap.action_add_event(key, input_changed[key])
	Global.old_input_changed = input_changed
		
	_on_back_button_pressed()


func _on_back_button_pressed():
	$"../menu".visible = true
	input_settings.visible = false
