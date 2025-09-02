extends Control

@onready var anim := $AnimationPlayer
@onready var audio := $AudioStreamPlayer

func _ready() -> void:
	anim.play("gameover")
	audio.play()

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
