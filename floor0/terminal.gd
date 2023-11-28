extends Interactable

@onready var terminal_ui := $Control
@onready var line_edit := $Control/LineEdit

var show_t := false
var password := "amelia"

# Called when the node enters the scene tree for the first time.
func _ready():
	terminal_ui.hide()

func action(player=null):
	show_t = !show_t
	if show_t:
		terminal_ui.show()
		var timer = Timer.new()
		timer.wait_time = 0.1
		timer.one_shot = true
		add_child(timer)  
		timer.start() 
		await timer.timeout  
		line_edit.grab_focus()
	else:
		line_edit.clear()
		terminal_ui.hide()


func _on_line_edit_text_submitted(new_text):
	if new_text.to_lower() == password:
		print("dobre hasło")
	else:
		print("złe hasło")
