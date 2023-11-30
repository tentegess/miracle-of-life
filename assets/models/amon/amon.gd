extends StaticBody3D

@export_node_path("Node3D") var keyPath

var key = null
var rotation_angle = 90
var rotate_step = 0
var rotation_axis = Vector3(0, 0, 1)  
var is_correct = false


# Called when the node enters the scene tree for the first time.
func _ready():
	if keyPath != null:
		key = get_node(keyPath).get_child(0)
		rotate_step = 2
		is_correct = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if key != null:
		key.global_position = self.global_position
		key.global_transform.basis = Basis().rotated(
			rotation_axis, deg_to_rad(-rotation_angle*rotate_step))


# Called when player left click
func place(player=null):
	if key != null:
		player.remove_object()
		player.picked_object = key
		key = null
	elif key == null and player.picked_object != null:
		key = player.picked_object
		player.picked_object = null
	check_correct()
		
		
# Called when player click "e"
func rotate_right():
	if key != null:
		rotate_step += 1
		check_correct()
		if rotate_step > 3:
			rotate_step = 0
			
			
func check_correct():
	if key and rotate_step == 2:
		if "cross" in key.get_owner().get_groups():
			is_correct = true
	else:
		is_correct = false
	get_tree().get_nodes_in_group("amon_counter")[0].action()
		
	
func return_correct():
	return is_correct
