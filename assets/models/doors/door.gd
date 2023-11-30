extends Interactable

@onready var animation := $AnimationPlayer
var is_open := false
var can_use := true
@export var locked := true
@export var unlock_by_key := true
#@export_node_path("RigidBody3D") var keyPath
@export var keyName := ""
var key

func _ready():
	pass

# Called when the node enters the scene tree for the first time.
func action(player=null):
	if can_use:
		if locked and player:
			if check_key(player) and unlock_by_key:
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
	$CollisionShape3D2.disabled = true
	$CollisionShape3D.disabled = false
	can_use = false
	is_open = false
	
func open():
	animation.play("door_open")
	$CollisionShape3D.disabled = true
	$CollisionShape3D2.disabled = false
	can_use = false
	is_open = true

func lock():
	animation.play("door_locked")
	can_use = false
	is_open = false
	
func unlock():
	$AudioStreamPlayer2D.stream = load("res://assets/sound/doors/doorUnlock.ogg")
	$AudioStreamPlayer2D.pitch_scale = 1.0
	$AudioStreamPlayer2D.play()
	locked = false

func check_key(player):
	if player.has_method("held_item"):
		if player.held_item():
			if keyName in player.held_item().get_parent().get_groups():
				player.picked_object = null
				return true
	return false
	
func door_lock_by_amon():
	locked = true
	if is_open:
		close()

func _on_animation_player_animation_finished(anim_name):
	can_use = true
