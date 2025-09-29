extends Control

signal confirmed
@onready var confirm_btn = $Confirm
@onready var first_btn = $HBoxContainer/Button
@onready var btns = $HBoxContainer.get_children()
@onready var name_input : LineEdit = $LineEdit

var chosen_character: int = -1
var selected = null

func _ready():
	get_tree().paused = true
	confirm_btn.disabled = true
	first_btn.grab_focus()
	name_input.connect("text_submitted", Callable(self, "_on_name_submitted"))
	name_input.text_changed.connect(_on_input_changed)
	for i in range(btns.size()):
		btns[i].pressed.connect(_on_character_chosen.bind(i))
	_play_all_btns()

func _on_input_changed(_new_text: String):
	_update_confirm_state()

func _on_character_chosen(index: int):
	chosen_character = index
	print("Chose character:", index)
	_update_confirm_state()
	
func _update_confirm_state():
	if name_input.text.strip_edges() != "" and chosen_character != -1:
		confirm_btn.disabled = false
	else:
		confirm_btn.disabled = true

func _on_character_button_pressed(character_name: String):
	selected = character_name
	print(selected)
	confirm_btn.disabled = false
	
func _on_confirm_button_pressed():
	var player_name = name_input.text.strip_edges()
	Globals.namae = player_name
	get_tree().paused = false
	emit_signal("confirmed")
	print(selected)
	if selected:
		Globals.chosen_character = selected
		get_tree().change_scene_to_file("res://scenes/gamebase.tscn")

func _play_all_btns() -> void:
	for b in btns:
		var sprite = b.get_node("AnimatedSprite2D")
		sprite.frame = 0
		sprite.play("default")

func _on_name_submitted(new_text):
	name_input.release_focus()
	confirm_btn.grab_focus()
