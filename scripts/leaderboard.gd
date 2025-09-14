extends Node2D

signal from_leaderboard
@export var vboxcontpath : NodePath
@onready var vboxcont := get_node(vboxcontpath)
var final_points : int = 0
var from_gameover : bool = false

func _ready() -> void:
	display_leaderboard(vboxcont)

func display_leaderboard(container: VBoxContainer) -> void:
	for child in container.get_children():
		child.queue_free()
	for entry in Globals.leaderboard:
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
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
