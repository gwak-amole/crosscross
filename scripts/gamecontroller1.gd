extends Node

@export var dialogue_ui_path: NodePath
@export var heart_ui_path : NodePath
@export var audio1 : NodePath
@export var audio2 : NodePath
@export var audio_enc : NodePath
@export var lives_start: int = 3

var lives: int
@onready var dialogue_ui := get_node(dialogue_ui_path)
@onready var hearts_box := get_node(heart_ui_path)
@onready var audioOne := get_node(audio1)
@onready var audioTwo := get_node(audio2)
@onready var audioEnc := get_node(audio_enc)
@onready var heart_nodes: Array[CanvasItem] = []


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	heart_nodes.clear()
	if hearts_box:
		for c in hearts_box.get_children():
			if c is CanvasItem:
				heart_nodes.append(c)
	else:
		push_error("Heart UI path not valid node haiyaa")
	lives = clamp(lives_start, 0, heart_nodes.size())
	_update_hearts()
	print("[Hearts] nodes:", heart_nodes.size(), " lives:", lives)

func _process(delta) -> void:
	if get_tree().paused == true:
		audioOne.playing = false
		audioTwo.playing = false
	elif audioOne.playing == false:
		audioOne.play()
	elif audioTwo.playing == false:
		audioTwo.play()

func hook_enemy(e: Node) -> void:
	if not e.has_signal("contacted"): return
	if not e.contacted.is_connected(_on_enemy_contacted):
		e.contacted.connect(_on_enemy_contacted)

func _on_enemy_contacted(enemy: Node) -> void:
	print("ctrl contacted so pausing")
	get_tree().paused = true
	audioEnc.play()
	print("ctrl paused =", get_tree().paused)
	
	var p = enemy.get("profile") if enemy else null
	if p == null:
		if is_instance_valid(enemy):
			enemy.queue_free()
		get_tree().paused = false
		return
	
	if dialogue_ui == null:
		push_error("dialogue_ui_path is not set to a DialogueUI node")
		return
	var picked:int = await dialogue_ui.show_dialogue_from_profile(p)
	print(picked)
	print(p.correct_idx)
	dialogue_ui.close_dialogue()
	var wrong : bool = picked != p.correct_idx
	if wrong:
		_lose_life()
	
	get_tree().paused = false
	if is_instance_valid(enemy):
		enemy.queue_free()
	
	if lives <= 0:
		_game_over()

func _update_hearts() -> void:
	var shown : int = clamp(lives, 0, heart_nodes.size())
	for i in  range(heart_nodes.size()):
		heart_nodes[i].visible = (i < shown)
	print("HEarts update -> lives:", lives, " shown", shown)
	

func _lose_life() -> void:
	lives = max(lives - 1, 0)
	_update_hearts()

func _game_over() -> void:
	get_tree().change_scene_to_file("res://scenes/gameover.tscn")
