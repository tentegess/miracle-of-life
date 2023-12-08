extends Node


func _input(event):
	if (
		(event is InputEventKey or 
		event is InputEventMouseButton) and event.pressed
	):
		get_tree().change_scene_to_file("res://start_menu/menu.tscn")
