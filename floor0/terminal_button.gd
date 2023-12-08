extends Control

@onready var lineedit = $"../LineEdit"
@onready var sound_player = $"../../AudioStreamPlayer"

@export var char : String
# Called when the node enters the scene tree for the first time.
func _ready():
	#modulate = Color(1, 1, 1, 0)
	self.connect("button_up", _on_button_up)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_up():
	sound_player.stop()
	sound_player.stream = load("res://assets/sound/terminal/click.ogg")
	sound_player.pitch_scale = randf_range(1.0,1.2)
	sound_player.play()
	lineedit.text += char
