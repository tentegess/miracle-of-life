extends Interactable

@onready var terminal_ui := $Control
@onready var line_edit := $Control/LineEdit

var show_t := false
var password := "amelia"
var Player = null
var used := false

signal unlock
# Called when the node enters the scene tree for the first time.
func _ready():
	terminal_ui.hide()
	set_process_input(true)

func _input(event):
	if show_t:
		if Input.is_action_just_released("pause"):
			hide_ui()
			

func action(player=null):
	Player = player
	show_t = !show_t
	if show_t:
		player.get_parent().get_tree().paused = true
		terminal_ui.show()
		var timer = Timer.new()
		timer.wait_time = 0.1
		timer.one_shot = true
		add_child(timer)  
		timer.start() 
		await timer.timeout  
		line_edit.grab_focus()
		Global.pause_game = true

func hide_ui():
	Player.get_parent().get_tree().paused = false
	terminal_ui.hide()
	line_edit.clear()
	terminal_ui.hide()

func _on_line_edit_text_submitted(new_text):
	if !used:
		if new_text.to_lower() == password:
			print("dobre hasło")
			unlock.emit()
			Global.pause_game = false
			hide_ui()
			used = true
		else:
			print("złe hasło")
