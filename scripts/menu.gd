extends Control
@onready var anim := $AnimationPlayer

func _ready() -> void:
	anim.play("mainmenu")

func _on_start_button_pressed() -> void:
	anim.play("exit")
	await anim.animation_finished
	get_tree().change_scene_to_file("res://scenes/gamebase.tscn")

func _on_instructions_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options.tscn")
