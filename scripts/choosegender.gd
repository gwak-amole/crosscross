extends Control
@export var first_btn_path : NodePath
@onready var first_btn := get_node(first_btn_path)
@onready var second_btn := $HBoxContainer/TextureButton2
@onready var confirm_btn := $confirmbtn
@onready var anim := $AnimationPlayer
var selected : int = 0
var last_button_before_confirm : TextureButton = null

func _ready():
	confirm_btn.disabled = true
	first_btn.grab_focus()
	first_btn.focus_mode = Control.FOCUS_ALL
	second_btn.focus_mode = Control.FOCUS_ALL
	confirm_btn.focus_mode = Control.FOCUS_ALL
	
	first_btn.connect("focus_entered", Callable(self, "_on_gender_btn_focus_entered").bind(first_btn))
	second_btn.connect("focus_entered", Callable(self, "_on_gender_btn_focus_entered").bind(second_btn))
	confirm_btn.connect("gui_input", Callable(self, "_on_confirm_btn_gui_input"))

func _unhandled_input(event):
	if event.is_action_pressed("ui_up"):
		print(" UP U P UUP UP ")
		if confirm_btn.has_focus() and last_button_before_confirm:
			last_button_before_confirm.grab_focus()

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
	print(last_button_before_confirm)


func _on_texture_button_2_pressed() -> void:
	selected = 2
	print(selected)
	confirm_btn.disabled = false
	highlight_button(second_btn)
	unhighlight_button(first_btn)
	print(last_button_before_confirm)

func highlight_button(btn: TextureButton):
	btn.modulate = Color(1, 1, 1, 1)
	btn.texture_normal = btn.texture_focused

func unhighlight_button(btn: TextureButton):
	btn.modulate = Color(1, 1, 1, 1)
	btn.texture_normal = btn.texture_hover

func _on_gender_btn_focus_entered(btn):
	last_button_before_confirm = btn

func _on_confirm_btn_gui_input(event):
	if event.is_action_pressed("ui_up") and last_button_before_confirm:
		last_button_before_confirm.grab_focus()
		get_viewport().set_input_as_handled()
