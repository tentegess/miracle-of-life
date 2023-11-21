extends Interactable

@onready var animation := $AnimationPlayer
var is_open := false
var can_use := true
@export var locked := true
@export_node_path("RigidBody3D") var keyPath
var key

func _ready():
	if keyPath != null:
		key = get_node(keyPath)

# Called when the node enters the scene tree for the first time.
func action(player=null):
	if can_use:
		if locked and player:
			if check_key(player):
				unlock()
			else:
				lock()
			return
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

func lock():
	animation.play("door_locked")
	can_use = false
	is_open = false
	
func unlock():
	$AudioStreamPlayer2D.stream = load("res://sound/doors/doorUnlock.ogg")
	$AudioStreamPlayer2D.pitch_scale = 1.0
	$AudioStreamPlayer2D.play()
	locked = false

func check_key(player):
	if player.has_method("held_item"):
		if player.held_item() == key:
			player.picked_object = null
			return true
	return false
	

func _on_animation_player_animation_finished(anim_name):
	can_use = true
