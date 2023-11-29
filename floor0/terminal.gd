extends Interactable

@onready var terminal_ui := $Control
@onready var line_edit := $Control/LineEdit
@onready var LineEditRegEx = RegEx.new()

var show_t := false
var password := "2137"
var Player = null
var used := false
var textt = ""

signal unlock
# Called when the node enters the scene tree for the first time.
func _ready():
	terminal_ui.hide()
	set_process_input(true)
	LineEditRegEx.compile("^[0-9.]*$")

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
			$AudioStreamPlayer.stream = load("res://assets/sound/terminal/wrong_pass.ogg")
			$AudioStreamPlayer.pitch_scale = 1.0
			$AudioStreamPlayer.play()
			print("złe hasło")


func _on_line_edit_text_changed(new_text):
	if LineEditRegEx.search(new_text):
		textt = str(new_text)
		$AudioStreamPlayer.stop()
		$AudioStreamPlayer.stream = load("res://assets/sound/terminal/click.ogg")
		$AudioStreamPlayer.pitch_scale = randf_range(1.0,1.2)
		$AudioStreamPlayer.play()
	else:
		line_edit.text = textt
		line_edit.set_caret_column(line_edit.text.length())
