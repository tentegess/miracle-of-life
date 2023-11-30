extends Interactable

@export var animation_name := ""
var can_use := true
var is_open := false

@export_node_path("AnimationPlayer") var animation_path
var animation = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if animation_path:
		animation = get_node(animation_path)

func action(player=null):
	if can_use:
		if is_open:
			is_open = false
			close()
		else:
			is_open = true
			open()
	
func close():
	if animation_name != "" && animation != null:
		animation.play_backwards(animation_name)
		#can_use = false
		is_open = false
	
func open():
	if animation_name != ""  && animation != null:
		animation.play(animation_name)
		#can_use = false
		is_open = true
