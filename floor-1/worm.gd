extends Node3D
	
func action(player):
	if player.has_method("held_item"):
		if player.held_item():
			print(player.held_item().get_groups())
			if "potion" in player.held_item().get_groups():
				player.picked_object = null
				get_tree().change_scene_to_file("res://ending/ending.tscn")
				return true
	return false
	
	
