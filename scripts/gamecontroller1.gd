extends Node

signal fever
signal fever_end
@export var dialogue_ui_path: NodePath
@export var heart_ui_path : NodePath
@export var audio1 : NodePath
@export var audio_enc : NodePath
@export var pointspath : NodePath
@export var coinspath : NodePath
@export var coiniconpath : NodePath
@export var coinsoundpath : NodePath
@export var splashsoundpath : NodePath
@export var charmsoundpath : NodePath
@export var shieldsoundpath : NodePath
@export var spawnerpath : NodePath
@export var anim_path : NodePath
@export var fevertext_path : NodePath
@export var texture_path : NodePath
@export var eventspawnerpath : NodePath
@export var fevertimerpath : NodePath
@export var shieldtextpath : NodePath
@export var charmpath : NodePath
@export var continuetimerpath : NodePath
@export var continuecanvaspath : NodePath
@export var charmtexturepath : NodePath
@export var animsplashpath : NodePath
@export var splashtextpath : NodePath
@export var lives_start: int = 3

var lives: int
@onready var dialogue_ui := get_node(dialogue_ui_path)
@onready var hearts_box := get_node(heart_ui_path)
@onready var audioOne := get_node(audio1)
@onready var audioEnc := get_node(audio_enc)
@onready var heart_nodes: Array[CanvasItem] = []
@onready var points := get_node(pointspath)
@onready var coins := get_node(coinspath)
@onready var spawner := get_node(spawnerpath)
@onready var anim := get_node(anim_path)
@onready var fevertext := get_node(fevertext_path)
@onready var texture := get_node(texture_path)
@onready var eventspawner := get_node(eventspawnerpath)
@onready var fevertimer := get_node(fevertimerpath)
@onready var shieldicon := get_node(shieldtextpath)
@onready var charm := get_node(charmpath)
@onready var continuetimer := get_node(continuetimerpath)
@onready var continuecanvas := get_node(continuecanvaspath)
@onready var coinicon := get_node(coiniconpath)
@onready var charmtexture := get_node(charmtexturepath)
@onready var animsplash := get_node(animsplashpath)
@onready var splashtext := get_node(splashtextpath)
@onready var coinsound := get_node(coinsoundpath)
@onready var splashsound := get_node(splashsoundpath)
@onready var charmsound := get_node(charmsoundpath)
@onready var shieldsound := get_node(shieldsoundpath)

var cor_idx : int
var times : int = 0
var points_int : int = 0
var points_frozen: bool = false
var no_of_coins: int = 0
var power = 1.2
var shield_active: bool = false
var cooldown : float = 5.0
var charm_active : bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	fevertimer.process_mode = Node.PROCESS_MODE_PAUSABLE
	fevertimer.one_shot = true
	if not fevertimer.timeout.is_connected(_on_fevertimer_timeout):
		fevertimer.timeout.connect(_on_fevertimer_timeout)
	if not fever.is_connected(_on_fever_request):
		fever.connect(_on_fever_request)
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
	fevertext.hide()
	texture.hide()
	charm.hide()
	shieldicon.hide()
	charmtexture.hide()
	splashtext.hide()

func _process(delta) -> void:
	if get_tree().paused == true:
		audioOne.playing = false
	elif audioOne.playing == false:
		audioOne.play()

func hook_enemy(e: Node) -> void:
	if not e.has_signal("contacted"): return
	if not e.contacted.is_connected(_on_enemy_contacted):
		e.contacted.connect(_on_enemy_contacted)

func _on_event_contacted(e: Node) -> void:
	var p = e.get("profile") if e else null
	if p == null:
		if is_instance_valid(e):
			e.queue_free()
		get_tree().paused = false
		return
		
	if p.effect == 1:
		shield_active == true
		shieldicon.show()

	if is_instance_valid(e):
		e.queue_free()
	

func _on_enemy_contacted(enemy: Node) -> void:
	if shield_active == true:
		shield_active = false
		shieldicon.hide()
		return
	coinicon.hide()
	coins.hide()
	fevertext.hide()
	texture.hide()
	charmtexture.hide()
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
	if lives > 0:
		continuecanvas.show()
		continuetimer.play("continuetimer")
		await continuetimer.animation_finished
	else:
		pass
	continuecanvas.hide()
	if dialogue_ui.thecharm == true:
		charm_active = true
		charmtexture.show()
	elif dialogue_ui.thecharm == false:
		charm_active = false
	coins.show()
	coinicon.show()
	
	get_tree().paused = false
	if is_instance_valid(enemy):
		enemy.queue_free()
	
	if lives <= 0:
		_game_over()
		
	if spawner.fever_active:
		print("CHECKING!")
		fevertext.show()
		texture.show()
		anim.play("fever_constant")
	else:
		print("fever not active")
		
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
	await get_tree().create_timer(cooldown).timeout
	while true:
		while get_tree().paused: 
			await get_tree().create_timer(0.1, true).timeout
		await _increment_points()
		await get_tree().create_timer(cooldown).timeout
		print("5 secs passed")

func _increment_points() -> void:
	if points_frozen == false:
		times += 1
		points_int += int(15 * pow(power, times))
		_update_points()
	elif points_frozen == true:
		pass

func _update_points() -> void:
	points.text = str(points_int)
	
func _on_coin_contacted(e: Node) -> void:
	no_of_coins += 1
	coinsound.play()
	coins.text = (str(no_of_coins))
	if no_of_coins >= 5:
		no_of_coins = 0
		coins.text = (str(no_of_coins))
		_fever_start()

func _on_shield_contacted(e: Node) -> void:
	shieldicon.show()
	shield_active = true
	shieldsound.play()

func _on_charm_contacted(e: Node) -> void:
	charmtexture.show()
	charm_active = true
	charmsound.play()

func _on_puddle_contacted(e:Node) -> void:
	print("puddle contacted")
	splashsound.play()
	animsplash.play("splashity")
	splashtext.show()
	spawner.slowpuddle()
	await animsplash.animation_finished
	animsplash.play("pulse")
		
func _fever_done() -> void:
	power = 1.2
	cooldown = 5.0
	print(power)
	anim.stop()
	anim.play("fever_fadeout")
	points.add_theme_color_override("font_color", Color(255, 255, 255))
	fevertext.hide()
	texture.hide()
	anim.stop()
	emit_signal("fever_end")

func _on_fever_request() -> void:
	spawner._on_fever_started()
	eventspawner._start_fever()
	
func _fever_start() -> void:
	anim.play("fever_constant")
	points.add_theme_color_override("font_color", Color(255, 204, 0))
	fevertext.show()
	texture.show()
	
	fevertimer.stop()
	fevertimer.wait_time = 8.0
	fevertimer.start()
	
	print("FEVER FEVER FEVER")
	emit_signal("fever")
	power = 1.3
	cooldown = 2.5

func _on_fevertimer_timeout() -> void:
	_fever_done()
