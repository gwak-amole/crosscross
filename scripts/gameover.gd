extends Control

@onready var anim := $AnimationPlayer
@onready var audio := $AudioStreamPlayer
@onready var points := $points/Panel/Label
var final_points : int = 0

func _ready() -> void:
	anim.play("gameover")
	audio.play()
	print(final_points)
	points.text = ("Points: " + str(final_points))

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
