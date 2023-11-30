extends Interactable

@export var animation_name := ""
var is_open := false

@export_node_path("AnimationPlayer") var animation_path
var animation = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if animation_path:
		animation = get_node(animation_path)
		animation.connect("animation_finished", animation_finished)

func action(player=null):
	if can_use:
	if Global.animator_can_use:
		if is_open:
			is_open = false
			close()
		else:
			is_open = true
			open()
	
func close():
	if animation_name != "" && animation != null:
		animation.play_backwards(animation_name)
		Global.animator_can_use = false
		is_open = false
	
func open():
	if animation_name != ""  && animation != null:
		animation.play(animation_name)
		Global.animator_can_use = false
		is_open = true
		
func animation_finished(anim_name):
	Global.animator_can_use = true
