extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animation_started(anim_name):
	$AudioStreamPlayer3D.stream = load("res://assets/sound/drawer/drawer_open.ogg")
	$AudioStreamPlayer3D.pitch_scale = 1.0
	$AudioStreamPlayer3D.play()
	
