extends Node3D
	
func ending(player):
	if player.has_method("held_item"):
		if player.held_item():
			if "potion" in player.held_item().get_parent().get_groups():
				player.picked_object = null
				get_tree().change_scene_to_file("res://ending.tscn")
				return true
	return false
