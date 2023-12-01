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
	var amon = get_child(0)
	var all_required_cross = []
	for row in range(0,5):
		for slot in range(0,5):
			all_required_cross.append(amon.get_child(row).get_child(slot).get_child(0))
	var cross_counter = 0
	for cross in all_required_cross:
		if cross.return_correct():
			cross_counter += 1
	if cross_counter == 9:
		unlock.emit()
	else:
		lock.emit()
	print(cross_counter)
