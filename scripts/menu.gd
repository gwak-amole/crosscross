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


func _on_button_pressed() -> void:
	var scene = load("res://scenes/leaderboard.tscn") as PackedScene
	var go := scene.instantiate()
	go.from_gameover = false
	var tree = get_tree()
	var old = tree.current_scene
	tree.root.add_child(go)
	tree.current_scene = go
	if old:
		old.queue_free()
