extends Node2D

signal from_leaderboard
@export var vboxcontpath : NodePath
@onready var vboxcont := get_node(vboxcontpath)
@onready var anim := $AnimationPlayer
@onready var title := $Label
@onready var subtitle := $Label3
@onready var btn := $Button
@onready var animback := $TextureRect
@onready var audio := $AudioStreamPlayer
var final_points : int = 0
var from_gameover : bool = false
var animstillplaying : bool = true
var childcount : int = 0

func _ready() -> void:
	animstillplaying = true
	Globalaudio.stop()
	animback.show()
	vboxcont.hide()
	title.hide()
	subtitle.hide()
	btn.hide()
	anim.play("enteranim")
	await anim.animation_finished
	animstillplaying = false
	audio.play()
	vboxcont.show()
	title.show()
	subtitle.show()
	btn.show()
	animback.hide()
	display_leaderboard(vboxcont)

func _process(delta) -> void:
	if animstillplaying == false:
		if audio.is_playing() == false:
			audio.play()

func display_leaderboard(container: VBoxContainer) -> void:
	for child in container.get_children():
		child.queue_free()
	var entries = Globals.leaderboard.slice(0,7)
	for entry in entries:
		var label = Label.new()
		var font = load("res://fonts/Jersey_10/Jersey10-Regular.ttf")
		label.add_theme_font_override("font", font)
		label.add_theme_font_size_override("font_size", 40)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.text = "%s - %d" % [entry["attempt"], entry["score"]]
		container.add_child(label)

func _on_button_pressed() -> void:
	if from_gameover:
		var scene = load("res://scenes/gameover.tscn") as PackedScene
		var go := scene.instantiate()
		go.from_leaderboard = true
		print(go.final_points)
		var tree = get_tree()
		var old = tree.current_scene
		tree.root.add_child(go)
		tree.current_scene = go
		if old:
			old.queue_free()
	else:
		from_gameover = false
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
