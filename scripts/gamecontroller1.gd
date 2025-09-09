extends Node

@export var dialogue_ui_path: NodePath
@export var heart_ui_path : NodePath
@export var audio1 : NodePath
@export var audio_enc : NodePath
@export var pointspath : NodePath
@export var lives_start: int = 3

var lives: int
@onready var dialogue_ui := get_node(dialogue_ui_path)
@onready var hearts_box := get_node(heart_ui_path)
@onready var audioOne := get_node(audio1)
@onready var audioEnc := get_node(audio_enc)
@onready var heart_nodes: Array[CanvasItem] = []
@onready var points := get_node(pointspath)

var cor_idx : int
var times : int = 0
var points_int : int = 0
var points_frozen: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	heart_nodes.clear()
	_loop_points()
	if hearts_box:
		for c in hearts_box.get_children():
			if c is CanvasItem:
				heart_nodes.append(c)
	else:
		push_error("Heart UI path not valid node haiyaa")
	lives = clamp(lives_start, 0, heart_nodes.size())
	_update_hearts()
	print("[Hearts] nodes:", heart_nodes.size(), " lives:", lives)
	dialogue_ui.branch_chosen.connect(_on_branch_chosen)

func _process(delta) -> void:
	if get_tree().paused == true:
		audioOne.playing = false
	elif audioOne.playing == false:
		audioOne.play()

func hook_enemy(e: Node) -> void:
	if not e.has_signal("contacted"): return
	if not e.contacted.is_connected(_on_enemy_contacted):
		e.contacted.connect(_on_enemy_contacted)

func _on_enemy_contacted(enemy: Node) -> void:
	points_int -= (points_int / 10)
	_update_points()
	times -= times/5
	points_frozen = true
	print("points frozen")
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
	print(cor_idx)
	dialogue_ui.close_dialogue()
	var wrong : bool = picked != cor_idx
	if wrong:
		_lose_life()
	
	get_tree().paused = false
	if is_instance_valid(enemy):
		enemy.queue_free()
	
	if lives <= 0:
		_game_over()
		
	if get_tree():
		await get_tree().create_timer(3.0).timeout
		points_frozen = false
		print("points unfrozen")

func _update_hearts() -> void:
	var shown : int = clamp(lives, 0, heart_nodes.size())
	for i in  range(heart_nodes.size()):
		heart_nodes[i].visible = (i < shown)
	print("HEarts update -> lives:", lives, " shown", shown)
	

func _lose_life() -> void:
	lives = max(lives - 1, 0)
	_update_hearts()
	points_frozen = true
	print("points frozen")
	points_int -= (points_int / 10)
	_update_points()
	times -= times/5
	await get_tree().create_timer(5.0).timeout
	points_frozen = false
	print("points unfrozen")

func _game_over() -> void:
	var scene = load("res://scenes/gameover.tscn") as PackedScene
	var go := scene.instantiate()
	go.final_points = points_int
	print(points_int)
	print(go.final_points)
	var tree = get_tree()
	var old = tree.current_scene
	tree.root.add_child(go)
	tree.current_scene = go
	if old:
		old.queue_free()
	
func _on_branch_chosen(idx: int) -> void:
	cor_idx = idx
	print("branch chosen; correct index =", cor_idx)

func _loop_points() -> void:
	await get_tree().create_timer(5.0).timeout
	while true:
		while get_tree().paused: 
			await get_tree().create_timer(0.1, true).timeout
		await _increment_points()
		await get_tree().create_timer(5.0).timeout
		print("5 secs passed")

func _increment_points() -> void:
	if points_frozen == false:
		times += 1
		points_int += int(15 * pow(1.2, times))
		_update_points()
	elif points_frozen == true:
		pass

func _update_points() -> void:
	points.text = str(points_int)
