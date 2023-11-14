extends CharacterBody3D



const JUMP_VELOCITY = 4.5

# move speed variants
const BASE_SPEED = 5.0
const CROUCH_SPEED = 2.5
const RUN_SPEED = 10.0
var mouse_sense = 2.5

# camera fov
var fov = 75.0
var run_fov = 85.0


# load elements of player node
@onready var head := $head
@onready var camera := $head/Camera3D
@onready var hitbox := $standard_hitbox
@onready var crouch_hitbox := $crouch_hitbox
@onready var crouch_raycast := $crouch_raycast
@onready var footstep_raycast := $footstep_raycast
@onready var anim_player := $AnimationPlayer
@onready var footstep_player := $footstep_player

# initial values when object is ready
@onready var parent := get_parent()
@onready var SPEED = 5.0
@onready var crouching = false

# sound variables
@onready var sound_distance := 0.0
@onready var play_freq := 0.1
@onready var play_period := 3.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	pass


func _input(event):
	if event is InputEventMouseMotion:
		if !parent.pause_game:
			head.rotation_degrees.y -= deg_to_rad(event.relative.x * mouse_sense)
			head.rotation_degrees.x -= deg_to_rad(event.relative.y * mouse_sense)
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))


func _physics_process(delta):
	movement(delta)


# player movement logic
func movement(delta):
	if Input.is_action_pressed("crouch"):
		play_period = 4.5
		move_cam("crouching")
		SPEED = CROUCH_SPEED
		hitbox.disabled = true
		crouch_hitbox.disabled = false
		camera.fov = lerp(camera.fov, fov, 5*delta)
	elif !crouch_raycast.is_colliding():
		move_cam("standing")
		hitbox.disabled = false
		crouch_hitbox.disabled = true
		if Input.is_action_pressed("run") and Input.is_action_pressed("move_forward"):
			play_period = 2.0
			SPEED = RUN_SPEED
			camera.fov = lerp(camera.fov, run_fov, 5*delta)
		else:
			play_period = 3.0
			SPEED = BASE_SPEED
			camera.fov = lerp(camera.fov, fov, 5*delta)
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if footstep_raycast.is_colliding() and is_on_floor():
			get_ground_type()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


# get ground type in way to choose sound to play
func get_ground_type():
	sound_distance += play_freq
	
	if sound_distance > play_period:
		sound_distance = 0.0
		var terrain  = footstep_raycast.get_collider().get_parent()
		if terrain != null:
			var group = terrain.get_groups()
			if group:
				play_step_sound(group[0])


# play step sound based on ground type
func play_step_sound(group : String):
	match group:
		"wood":
			footstep_player.stream = load("res://sound/step/wood/0.ogg")
			
		"grass":
			footstep_player.stream = load("res://sound/step/grass/0.ogg")
			
		"metal":
			footstep_player.stream = load("res://sound/step/metal/0.ogg")
			
		_:
			return
			
	footstep_player.pitch_scale = randf_range(0.6,0.9)
	footstep_player.play()


# move down camera at crouching
func move_cam(state):
	match state:
		"crouching":
			if !crouching:
				anim_player.play("crouch_animation")
			crouching = true
		"standing":
			if crouching:
				anim_player.play_backwards("crouch_animation")
			crouching = false
	

