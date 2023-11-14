extends CharacterBody3D



const JUMP_VELOCITY = 4.5
const BASE_SPEED = 5.0
const CROUCH_SPEED = 2.5
const RUN_SPEED = 10.0
var mouse_sense = 2.5

var fov = 75.0
var run_fov = 85.0

@onready var head := $head
@onready var camera := $head/Camera3D
@onready var hitbox := $standard_hitbox
@onready var crouch_hitbox := $crouch_hitbox
@onready var raycast := $RayCast3D
@onready var anim_player := $AnimationPlayer
@onready var parent := get_parent()
@onready var SPEED = 5.0
@onready var crouching = false


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
	
	if Input.is_action_pressed("crouch"):
		move_cam("crouching")
		SPEED = CROUCH_SPEED
		hitbox.disabled = true
		crouch_hitbox.disabled = false
		camera.fov = lerp(camera.fov, fov, 5*delta)
	elif !raycast.is_colliding():
		move_cam("standing")
		hitbox.disabled = false
		crouch_hitbox.disabled = true
		if Input.is_action_pressed("run") and Input.is_action_pressed("move_forward"):
			SPEED = RUN_SPEED
			camera.fov = lerp(camera.fov, run_fov, 5*delta)
		else:
			SPEED = BASE_SPEED
			camera.fov = lerp(camera.fov, fov, 5*delta)
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	

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
	

