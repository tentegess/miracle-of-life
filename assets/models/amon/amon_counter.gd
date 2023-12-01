extends Node

signal unlock
signal lock

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func action():
	var all_required_cross = get_tree().get_nodes_in_group("amon_required")
	var cross_counter = 0
	for cross in all_required_cross:
		if cross.return_correct():
			cross_counter += 1
	if cross_counter == 9:
		unlock.emit()
	else:
		lock.emit()
	print(cross_counter)
