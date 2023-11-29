extends LineEdit

@onready var LineEditRegEx = RegEx.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	LineEditRegEx.compile("^[0-9.]*$")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_text_changed(new_text):
	var filtered_text = ""
	for character in new_text:
		if ord(character) >= ord('0') and ord(character) <= ord('9'):
			filtered_text += character
	text = filtered_text
