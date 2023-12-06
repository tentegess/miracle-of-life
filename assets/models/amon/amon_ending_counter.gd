extends Node3D

var correct_amons = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$"../Amon".connect("unlock", amon_correct)
	$"../Amon".connect("lock", amon_incorrect)
	$"../Amon2".connect("unlock", amon_correct)
	$"../Amon2".connect("lock", amon_incorrect)
	$"../Amon3".connect("unlock", amon_correct)
	$"../Amon3".connect("lock", amon_incorrect)
	$"../Amon4".connect("unlock", amon_correct)
	$"../Amon4".connect("lock", amon_incorrect)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func amon_correct():
	correct_amons += 1
	if correct_amons == 4:
		print('tutaj ending')
	

func amon_incorrect():
	correct_amons -= 1
