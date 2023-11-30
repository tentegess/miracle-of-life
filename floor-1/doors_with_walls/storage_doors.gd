extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$"../Amon".connect("unlock", unlock_door)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func unlock_door():
	var door = find_child("Door")
	if door:
		door.unlock()
	
