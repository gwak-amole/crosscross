extends Control
@onready var animback := $animation
@onready var anim := $AnimationPlayer
@onready var blank := $TextureRect2
@onready var bg := $TextureRect
@onready var lbl := $Label
@onready var btn := $Button
@onready var audio := $AudioStreamPlayer

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _ready() -> void:
	Globalaudio.volume_db = -5
	animback.show()
	blank.show()
	bg.hide()
	lbl.hide()
	btn.hide()
	anim.play("enteranim")
	await anim.animation_finished
	Globalaudio.volume_db = 0
	blank.hide()
	bg.show()
	lbl.show()
	btn.show()
	animback.hide()
