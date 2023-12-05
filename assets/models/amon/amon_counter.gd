extends Node

signal unlock
signal lock

@export var required_crosses = 9
var is_not_active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func action():
	var all_required_cross = []
	for row in range(0,5):
		for slot in range(0,5):
			var amon = get_child(0).get_child(row).get_child(slot).get_child(0)
			if "amon_required" in amon.get_groups():
				all_required_cross.append(amon)
	var cross_counter = 0
	for cross in all_required_cross:
		if cross.return_correct():
			cross_counter += 1
	if cross_counter == required_crosses and !is_not_active:
		unlock.emit()
		is_not_active = !is_not_active
	elif is_not_active:
		lock.emit()
		is_not_active = !is_not_active
