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

#stamina
var max_stamina = 100.0
var stamina = max_stamina
var stamina_recovery_rate = 15.0 
var stamina_depletion_rate = 25.0
var can_run := true

# variables that prevent action if player move into wall
var previous_position = Vector3()
var is_moving = false

# picking up item
var picked_object
var pull_power = 4 * RUN_SPEED
var rotation_power = 0.05
var locked = false
var clicked = false
var interaction = false

# load elements of player node
@onready var head := $head
@onready var camera := $head/Camera3D
@onready var hitbox := $standard_hitbox
@onready var crouch_hitbox := $crouch_hitbox
@onready var crouch_raycast := $crouch_raycast
@onready var footstep_raycast := $footstep_raycast
@onready var anim_player := $AnimationPlayer
@onready var footstep_player := $footstep_player
@onready var run_player := $run_player

# picking items variables
@onready var reach := $head/Camera3D/reach
@onready var hand := $head/Camera3D/hand
@onready var joint := $head/Camera3D/Generic6DOFJoint3D
@onready var staticbody := $head/Camera3D/StaticBody3D
@onready var item_view := $head/Camera3D/itemView
@onready var crosshair := $head/Camera3D/crosshair
@onready var note_view := $head/Camera3D/note_view.get_node("Control").get_node("note")
@onready var note_sound := $head/Camera3D/note_view.get_node("Control").get_node("note_sound")

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
	if !parent.pause_game:
		if event is InputEventMouseMotion:
			if !locked:
				head.rotation_degrees.y -= deg_to_rad(event.relative.x * mouse_sense)
				head.rotation_degrees.x -= deg_to_rad(event.relative.y * mouse_sense)
				head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))
			
		if Input.is_action_just_pressed("left_click") and not clicked:
			interaction = false
			if not note_view.visible:
				pick_up()
				read_note()
			if not interaction:
				remove_object()	
			clicked = true
			
		if Input.is_action_just_released("left_click"):
			clicked = false
						
		if Input.is_action_pressed("right_click"):
			if picked_object != null:
				locked = true
				rotate_object(event)
		if Input.is_action_just_released("right_click"):
			locked = false
			
		if Input.is_action_just_pressed("interact"):
			var interacted = reach.get_collider()
			if interacted != null and interacted.has_method("action"):
				interacted.action(self)


func _physics_process(delta):
	check_movement()
	handle_stamina(delta)
	movement(delta)
	check_cursor()
	item_movement()


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
		if Input.is_action_pressed("run") and Input.is_action_pressed("move_forward") and can_run:
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
	character_colision()


func character_colision():
	for collision_index in get_slide_collision_count():
		var collision = get_slide_collision(collision_index)
		if collision.get_collider() is RigidBody3D:
			var collider = collision.get_collider()
			var central_impulse_force = -collision.get_normal()  * 0.1 / collider.get_mass()
			collider.apply_central_impulse(central_impulse_force)


# get ground type in way to choose sound to play
func get_ground_type():
	sound_distance += play_freq
	
	if sound_distance > play_period and is_moving:
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
			footstep_player.stream = load("res://assets/sound/step/wood/0.ogg")
			
		"grass":
			footstep_player.stream = load("res://assets/sound/step/grass/0.ogg")
			
		"metal":
			footstep_player.stream = load("res://assets/sound/step/metal/0.ogg")
			
		_:
			return
			
	footstep_player.pitch_scale = randf_range(0.6,0.9)
	footstep_player.play()

func handle_stamina(delta):
	if (Input.is_action_pressed("run") and Input.is_action_pressed("move_forward")
	and can_run and !crouching and is_moving):
		stamina -= stamina_depletion_rate * delta
		stamina = max(stamina, 0)
		if stamina <= 0:
			if can_run:
				run_player.stream = load("res://sound/player/hiperventilation.ogg")
				run_player.pitch_scale = 1.0
				run_player.play()
			can_run = false
	else:
		stamina += stamina_recovery_rate * delta
		stamina = min(stamina, max_stamina)
		if stamina >= 40:
			run_player.stop()
			can_run = true
	#print(stamina)
		

# check if player position change
func check_movement():
	is_moving = global_transform.origin != previous_position
	previous_position = global_transform.origin
		
		
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
	
	
func check_cursor():
	var collider = reach.get_collider()
	if collider != null and (collider is RigidBody3D or "note" in collider.get_groups() or collider.has_method("action")):
		crosshair.visible = true
	else:
		crosshair.visible = false


func pick_up():
	var collider = reach.get_collider()
	if collider != null and collider is RigidBody3D:
		if picked_object != null:
			remove_object()
		picked_object = collider
		picked_object.global_transform.origin = hand.global_transform.origin
		picked_object.collision_mask = 0
		picked_object.collision_layer = 0
		interaction = true
		
		
func read_note():
	var collider = reach.get_collider()
	if collider != null and "note" in collider.get_groups():
		note_view.texture = collider.get_node("note").texture
		note_view.visible = true
		note_sound.play()
		interaction = true
		
		
func rotate_object(event):
	if picked_object != null:
		if event is InputEventMouseMotion:
			joint.set_node_b(picked_object.get_path())
			staticbody.rotate_x(deg_to_rad(event.relative.y * rotation_power))
			staticbody.rotate_y(deg_to_rad(event.relative.x * rotation_power))
			
			
func remove_object():
	if note_view.visible:
		note_view.visible = false
	elif picked_object != null:
		joint.set_node_b(joint.get_path())
		picked_object.collision_mask = 1
		picked_object.collision_layer = 1
		picked_object.linear_velocity = Vector3.ZERO
		picked_object = null
		
		
func item_movement():
	if picked_object != null:
		if locked:
			picked_object.global_transform.origin = item_view.global_transform.origin
		else:
			staticbody.global_transform.basis = head.global_transform.basis
			picked_object.global_transform.basis = head.global_transform.basis
			picked_object.global_transform.origin = hand.global_transform.origin
			

func held_item():
	return picked_object
