extends Node

signal unlock

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func action():
	var test = get_tree().get_nodes_in_group("amon_required")
	var test2 = 0
	for t in test:
		if t.return_correct():
			test2 += 1
	if test2 == 9:
		unlock.emit()
