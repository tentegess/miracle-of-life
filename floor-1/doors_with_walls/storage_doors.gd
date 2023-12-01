extends Node3D

@onready var light1 = $light1
@onready var light2 = $light2

var door = null
var locked = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$"../Amon".connect("unlock", unlock_door)
	$"../Amon".connect("lock", lock_door)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func unlock_door():
	var door = find_child("Door")
	if door and locked:
		locked = false
		door.unlock()
		light1.visible = false
		light2.visible = false
	

func lock_door():
	var door = find_child("Door")
	if door and !locked:
		locked = true
		door.door_lock_by_amon()
		light1.visible = true
		light2.visible = true
