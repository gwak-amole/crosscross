extends Control
@export var first_btn_path : NodePath
@onready var first_btn := get_node(first_btn_path)
@onready var second_btn := $HBoxContainer/TextureButton2
@onready var confirm_btn := $confirmbtn
@onready var anim := $AnimationPlayer
var selected : int = 0

func _ready():
	confirm_btn.disabled = true
	first_btn.grab_focus()

func _on_confirmbtn_pressed() -> void:
	if selected:
		if selected == 1:
			Globals.chosen_gender = selected
			anim.play("fade_out")
			await anim.animation_finished
			get_tree().change_scene_to_file("res://scenes/characterselect.tscn")
		elif selected == 2:
			Globals.chosen_gender = selected
			anim.play("fade_out")
			await anim.animation_finished
			get_tree().change_scene_to_file("res://scenes/characterselectwoman.tscn")

func _on_texture_button_pressed() -> void:
	selected = 1
	print(selected)
	confirm_btn.disabled = false
	highlight_button(first_btn)
	unhighlight_button(second_btn)


func _on_texture_button_2_pressed() -> void:
	selected = 2
	print(selected)
	confirm_btn.disabled = false
	highlight_button(second_btn)
	unhighlight_button(first_btn)

func highlight_button(btn: TextureButton):
	btn.modulate = Color(1, 1, 1, 1)
	btn.texture_normal = btn.texture_focused

func unhighlight_button(btn: TextureButton):
	btn.modulate = Color(1, 1, 1, 1)
	btn.texture_normal = btn.texture_hover
