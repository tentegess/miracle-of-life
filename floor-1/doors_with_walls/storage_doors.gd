extends Node3D

@onready var light1 = $light1
@onready var light2 = $light2

var door = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$"../Amon".connect("unlock", unlock_door)
	$"../Amon".connect("lock", lock_door)


func unlock_door():
	var door = find_child("Door")
	if door:
		door.unlock()
		light1.visible = false
		light2.visible = false


func lock_door():
	var door = find_child("Door")
	if door:
		door.door_lock_by_amon()
		light1.visible = true
		light2.visible = true
