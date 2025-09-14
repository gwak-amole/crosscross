extends Control

@onready var anim := $AnimationPlayer
@onready var audio := $AudioStreamPlayer
@onready var points := $points/Panel/Label
var final_points : int = 0
var from_leaderboard := false

func _ready() -> void:
	anim.play("gameover")
	audio.play()
	print(final_points)
	points.text = ("Points: " + str(final_points))
	if from_leaderboard == true:
		pass
		from_leaderboard = false
	elif from_leaderboard == false:
		Globals.attempt += 1
		add_score((Globals.attempt), final_points)

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_button_pressed() -> void:
	if from_leaderboard == true:
		var scene = load("res://scenes/leaderboard.tscn") as PackedScene
		var go = scene.instantiate()
		go.from_gameover = true
		var tree = get_tree()
		var old = tree.current_scene
		tree.root.add_child(go)
		tree.current_scene = go
		if old:
			old.queue_free()
		from_leaderboard = false
	elif from_leaderboard == false:
		var scene = load("res://scenes/leaderboard.tscn") as PackedScene
		var go := scene.instantiate()
		go.final_points = final_points
		go.from_gameover = true
		print(go.final_points)
		var tree = get_tree()
		var old = tree.current_scene
		tree.root.add_child(go)
		tree.current_scene = go
		if old:
			old.queue_free()

func add_score(attempt: int, score: int) -> void:
	Globals.leaderboard.append({"attempt": attempt, "score": score})
	sort_leaderboard()
	
func sort_leaderboard() -> void:
	Globals.leaderboard.sort_custom(_sort_by_score)

func _sort_by_score(a, b) -> bool:
	return a["score"] > b["score"]
