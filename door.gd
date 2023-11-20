extends Interactable

@onready var animation := $AnimationPlayer
var is_open := false
var can_use := true

# Called when the node enters the scene tree for the first time.
func action():
	if can_use:
		if is_open:
			is_open = false
			close()
		else:
			is_open = true
			open()
		
func close():
	animation.play("door_close")
	can_use = false
	is_open = false
	
func open():
	animation.play("door_open")
	can_use = false
	is_open = true
	
func _on_animation_player_animation_finished(anim_name):
	can_use = true
