extends Control

signal confirmed
@onready var confirm_btn = $Confirm
@onready var first_btn = $HBoxContainer/Button
@onready var btns = $HBoxContainer.get_children()
var selected = null

func _ready():
	get_tree().paused = true
	confirm_btn.disabled = true
	first_btn.grab_focus()
	_play_all_btns()

func _on_character_button_pressed(character_name: String):
	selected = character_name
	print(selected)
	confirm_btn.disabled = false
	
func _on_confirm_button_pressed():
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
