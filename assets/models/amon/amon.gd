extends StaticBody3D

var key = null
var rotation_angle = 90
var rotate_step = 0
var rotation_axis = Vector3(0, 0, 1)  

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if key != null:
		key.global_position = self.global_position
		key.global_transform.basis = Basis().rotated(
			rotation_axis, deg_to_rad(-rotation_angle*rotate_step))


# Called when player left click
func place(player=null):
	print("lol")
	if key != null:
		player.remove_object()
		player.picked_object = key
		key = null
	elif key == null and player.picked_object != null:
		print("odkładam")
		key = player.picked_object
		player.picked_object = null
		
# Called when player left click
func rotate_right():
	if key != null:
		rotate_step += 1
		if rotate_step > 3:
			rotate_step = 0
