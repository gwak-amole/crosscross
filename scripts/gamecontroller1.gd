extends Node

signal fever
signal fever_end
signal tutorial(yes:bool)
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
@export var tutanimpath : NodePath
@export var wyltutlabelpath : NodePath
@export var wyltutbtnpath : NodePath
@export var wyltutbtn2path : NodePath
@export var gameplayrootpath : NodePath
@export var tutexplainpath : NodePath
@export var begintutpath : NodePath
@export var tutorialhboxpath : NodePath
@export var tuttextpath : NodePath
@export var citylayerpath : NodePath
@export var subwaylayerpath : NodePath
@export var characterspath : NodePath
@export var eventspath : NodePath
@export var subswitchanimpath : NodePath
@export var subswitchtextpath : NodePath
@export var maincharapath : NodePath
@export var environmentalmishappath : NodePath
@export var stairexitpath : NodePath
@export var stairs_scene : PackedScene
@export var subwayentriespath : NodePath
@export var subwaypointpath : NodePath
@export var cardswiperspath : NodePath
@export var pausemenupath : NodePath
@export var cardswipingactivitypath : NodePath
@export var trainconductordialoguepath : NodePath
@export var countrylayerpath : NodePath
@export var countryblossomslayerpath : NodePath
@export var countryswitchanimpath : NodePath
@export var countrycollisionpath : NodePath
@export var countryexitpath : NodePath
@export var countryswitchtextpath : NodePath
@export var trainconductorspawnerpath : NodePath
@export var dogactivitypath : NodePath
@export var trainaudiopath : NodePath
@export var animalspath : NodePath
@export var enemyspawningcountrypath : NodePath
@export var riverexitpath : NodePath
@export var riverpath : NodePath
@export var enemyspawningriverpath : NodePath
@export var boatspath : NodePath
@export var yanagawatreepath : NodePath
@export var balanceboatpath : NodePath
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
@onready var tutanim := get_node(tutanimpath)
@onready var tutexplain := get_node(tutexplainpath)
@onready var wyltutlabel := get_node(wyltutlabelpath)
@onready var wyltutyes := get_node(wyltutbtnpath)
@onready var wyltutno := get_node(wyltutbtn2path)
@onready var gameplayroot := get_node(gameplayrootpath)
@onready var begintut := get_node(begintutpath)
@onready var tutorialhbox := get_node(tutorialhboxpath)
@onready var tuttext := get_node(tuttextpath)
@onready var citylayer := get_node(citylayerpath)
@onready var subwaylayer := get_node(subwaylayerpath)
@onready var characters := get_node(characterspath)
@onready var events := get_node(eventspath)
@onready var subswitchanim := get_node(subswitchanimpath)
@onready var subswitchtext := get_node(subswitchtextpath)
@onready var mainchara := get_node(maincharapath)
@onready var envir := get_node(environmentalmishappath)
@onready var stairexit := get_node(stairexitpath)
@onready var subwayentries := get_node(subwayentriespath)
@onready var subwaypoint := get_node(subwaypointpath)
@onready var cardswipers := get_node(cardswiperspath)
@onready var pausemenu := get_node(pausemenupath)
@onready var cardswipingactivity := get_node(cardswipingactivitypath)
@onready var train_dialogue_ui := get_node(trainconductordialoguepath)
@onready var countrylayer := get_node(countrylayerpath)
@onready var countryswitchanim := get_node(countryswitchanimpath)
@onready var countrycollision := get_node(countrycollisionpath)
@onready var countryblossomslayer := get_node(countryblossomslayerpath)
@onready var countryexit := get_node(countryexitpath)
@onready var countryswitchtext := get_node(countryswitchtextpath)
@onready var trainconductors := get_node(trainconductorspawnerpath)
@onready var dogactivity := get_node(dogactivitypath)
@onready var trainaudio := get_node(trainaudiopath)
@onready var enemyspawningcountry := get_node(enemyspawningcountrypath)
@onready var animals := get_node(animalspath)
@onready var river := get_node(riverpath)
@onready var riverexit := get_node(riverexitpath)
@onready var enemyspawningriver := get_node(enemyspawningriverpath)
@onready var boats := get_node(boatspath)
@onready var yanagawatrees := get_node(yanagawatreepath)
@onready var balanceboatactivity := get_node(balanceboatpath)

var cor_idx : int
var times : int = 0
var points_int : int = 0
var points_frozen: bool = false
var no_of_coins: int = 0
var power = 1.2
var shield_active: bool = false
var cooldown : float = 5.0
var charm_active : bool = false
var tutorial_wanted : bool = false
var puddle_tut_wanted : bool = false
var charm_used : bool = true
var exiting_subway := false
var swipercooldown = false
var swipe_used := false
var in_transition_buffer = false
var transitioning = false
var exiting_country := false
var from_country := false
var exiting_river := false
var from_river := false
var stop_audio := false

func _ready() -> void:
	set_character(Globals.chosen_character)
	citylayer.visible = true
	subwaylayer.visible = false
	countrylayer.visible = false
	river.visible = false
	countryblossomslayer.visible = false
	yanagawatrees.visible = false
	subswitchtext.hide()
	wyltutlabel.hide()
	wyltutyes.hide()
	wyltutno.hide()
	tuttext.hide()
	fevertext.hide()
	countrycollision.disabled = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	fevertimer.process_mode = Node.PROCESS_MODE_PAUSABLE
	wyltutyes.process_mode = Node.PROCESS_MODE_ALWAYS
	wyltutno.process_mode = Node.PROCESS_MODE_ALWAYS
	wyltutyes.grab_focus()
	fevertimer.one_shot = true
	if not fevertimer.timeout.is_connected(_on_fevertimer_timeout):
		fevertimer.timeout.connect(_on_fevertimer_timeout)
	if not fever.is_connected(_on_fever_request):
		fever.connect(_on_fever_request)
	begintut.tutorialfinished.connect(_on_tutorial_finished)
	dialogue_ui.charm_used.connect(_on_charm_used)
	cardswipingactivity.connect("done", Callable(self, "_on_swipe_done"))
	dogactivity.connect("activity_ended", Callable(self, "_on_dog_activity_ended"))
	balanceboatactivity.connect("activity_ended", Callable(self, "_on_boat_activity_ended"))
	heart_nodes.clear()
	if hearts_box:
		for c in hearts_box.get_children():
			if c is CanvasItem:
				heart_nodes.append(c)
	else:
		push_error("Heart UI path not valid node haiyaa")
	lives = clamp(lives_start, 0, heart_nodes.size())
	_update_hearts()
	dialogue_ui.branch_chosen.connect(_on_branch_chosen)
	fevertext.hide()
	texture.hide()
	charm.hide()
	shieldicon.hide()
	charmtexture.hide()
	splashtext.hide()
	coinicon.hide()
	coins.hide()
	points.hide()
	hearts_box.hide()
	enemyspawningcountry.set_deferred("monitoring", false)
	enemyspawningcountry.set_deferred("monitorable", false)
	enemyspawningriver.set_deferred("monitoring", false)
	enemyspawningriver.set_deferred("monitorable", false)
	countryexit.set_deferred("monitoring", false)
	countryexit.set_deferred("monitorable", false)
	riverexit.set_deferred("monitoring", false)
	riverexit.set_deferred("monitorable", false)
	if not (wyltutyes as BaseButton).pressed.is_connected(_on_yes_pressed):
		(wyltutyes as BaseButton).pressed.connect(_on_yes_pressed)
	if not (wyltutno as BaseButton).pressed.is_connected(_on_no_pressed):
		(wyltutno as BaseButton).pressed.connect(_on_no_pressed)
	await _tutorial_ask()
	if tutorial_wanted:
		begintut.show()
		puddle_tut_wanted = true
		await begintut.tutorialfinished
		_loop_points()
		coinicon.show()
		coins.show()
		points.show()
		hearts_box.show()
	else:
		_loop_points()
		begintut.hide()
		coinicon.show()
		coins.show()
		points.show()
		hearts_box.show()

func _process(delta) -> void:
	if stop_audio:
		pass
	else:
		if get_tree().paused == true:
			audioOne.stream_paused = true
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
	if in_transition_buffer or transitioning:
		return
	if shield_active == true:
		shield_active = false
		shieldicon.hide()
		return
	coinicon.hide()
	coins.hide()
	fevertext.hide()
	texture.hide()
	charmtexture.hide()
	points.hide()
	points_int -= (points_int / 10)
	_update_points()
	times -= times/5
	points_frozen = true
	get_tree().paused = true
	audioEnc.play()
	
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
		if dialogue_ui.delinq_success:
			pass
		else:
			_lose_life()
	dialogue_ui.delinq_success = false
	if lives > 0:
		continuecanvas.show()
		continuetimer.play("continuetimer")
		await continuetimer.animation_finished
	else:
		pass
	continuecanvas.hide()
	coins.show()
	coinicon.show()
	points.show()
	
	get_tree().paused = false
	audioOne.stream_paused = false
	if is_instance_valid(enemy):
		enemy.queue_free()
	
	if lives <= 0:
		_game_over()
		
	if spawner.fever_active:
		fevertext.show()
		texture.show()
		anim.play("fever_constant")
	else:
		pass
	if charm_used == false:
		charmtexture.show()
		charm_active = true
	elif charm_used:
		charmtexture.hide()
		charm_active = false
	if get_tree():
		await get_tree().create_timer(3.0).timeout
		points_frozen = false
		print("points unfrozen")

func _update_hearts() -> void:
	var shown : int = clamp(lives, 0, heart_nodes.size())
	for i in  range(heart_nodes.size()):
		heart_nodes[i].visible = (i < shown)	

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
	charm_used = false

func _on_puddle_contacted(e:Node) -> void:
	if puddle_tut_wanted:
		if tutanim.is_playing() == false:
			tutexplain.show()
			tutanim.play("puddle")
			puddle_tut_wanted = false
		else:
			pass
	splashsound.play()
	animsplash.play("splashity")
	splashtext.show()
	spawner.slowpuddle()
	await animsplash.animation_finished
	animsplash.play("pulse")
	await tutanim.animation_finished
	tutexplain.hide()
		
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
	
	emit_signal("fever")
	power = 1.3
	cooldown = 2.5

func _on_fevertimer_timeout() -> void:
	_fever_done()

func _tutorial_ask() -> void:
	_focus_tutorial_ask()
	tuttext.show()
	wyltutlabel.show()
	wyltutyes.show()
	wyltutno.show()
	get_tree().paused = true
	
	await get_tree().process_frame
	var yes: bool = await tutorial
	print(yes)
	
	wyltutlabel.hide()
	wyltutyes.hide()
	wyltutno.hide()
	tuttext.hide()
	

func _on_yes_pressed() -> void:
	tutorial_wanted = true
	emit_signal("tutorial", true)

func _on_no_pressed() -> void:
	tutorial_wanted = false
	emit_signal("tutorial", false)

func _on_tutorial_finished() -> void:
	get_tree().paused = false
	
func _on_charm_used() -> void:
	charm_active = false
	charm_used = true

func _focus_tutorial_ask() -> void:
	var cols: Array = []
	for n in tutorialhbox.get_children():
		if n is Button and n.visible:
			(n as Control).focus_mode = Control.FOCUS_ALL
			cols.append(n)
	
	for i in cols.size():
		var b := cols[i] as Control
		b.focus_neighbor_left = cols[(i-1 + cols.size()) % cols.size()].get_path()
		b.focus_neighbor_right = cols[(i+1) % cols.size()].get_path()
		
	if cols.size() > 0:
		await get_tree().process_frame
		(cols[0] as Control).grab_focus()

func _on_subway_exit_triggered():
	if exiting_subway:
		return
	transitioning = true
	exiting_subway = true
	stairexit.set_deferred("monitoring", false)
	stairexit.set_deferred("monitorable", false)
	subswitchtext.show()
	subswitchanim.play("fade_in")
	await subswitchanim.animation_finished
	transitioning = false
	subwaylayer.visible = false
	citylayer.visible = true
	_reset_player_position()
	
	for child in characters.get_children():
		if child != mainchara:
			child.queue_free()
	for child in events.get_children():
		child.queue_free()
	subswitchtext.hide()
	for child in envir.get_children():
		child.queue_free()
	for child in subwayentries.get_children():
		if child.name == "stairs":
			child.queue_free()
	for child in cardswipers.get_children():
		child.queue_free()
	for child in cardswipers.get_children():
		child.queue_free()
	for child in trainconductors.get_children():
		child.queue_free()
	
	subswitchanim.play("fade_out")
	await subswitchanim.animation_finished
	
	subswitchtext.hide()
	exiting_subway = false
	from_country = false
	

func _on_stairexit_body_entered(body: Node2D) -> void:
	if body != mainchara:
		return
	if subwaylayer.visible == false:
		return
	if not exiting_subway:
		_on_subway_exit_triggered()

func _on_subwayentry_contacted(entry) -> void:
	print(entry)
	_switch_scene_to_subway()

func _switch_scene_to_subway() -> void:
	if not from_country or not from_river:
		subswitchtext.show()
		subswitchanim.play("fade_in")
		await subswitchanim.animation_finished
	stairexit.set_deferred("monitoring", true)
	stairexit.set_deferred("monitorable", true)
	citylayer.visible = false
	subwaylayer.visible = true
	print("Before:", mainchara.global_position)
	mainchara.global_position = subwaypoint.global_position
	print("After:", mainchara.global_position)
	
	var cam := get_viewport().get_camera_2d()
	cam.global_position = subwaypoint.global_position
	
	for l in subwaylayer.get_children():
		if l is ParallaxLayer:
			l.motion_offset = Vector2.ZERO
	_reset_player_position()
	if not from_country or not from_river:
		subswitchanim.play("fade_out")
	for child in characters.get_children():
		if child != mainchara:
			child.queue_free()
	for child in events.get_children():
		child.queue_free()
	for child in envir.get_children():
		child.queue_free()
	for child in cardswipers.get_children():
		child.queue_free()
	for child in cardswipers.get_children():
		child.queue_free()
	for child in boats.get_children():
		child.queue_free()
	for child in trainconductors.get_children():
		child.queue_free()
	subswitchtext.hide()
	from_country = false
	from_river = false

func _reset_player_position():
	mainchara.global_position = subwaypoint.global_position
	
func _on_swiper_contacted():
	if swipe_used:
		print("Swipe activity already done so ignoring")
		return
	if in_transition_buffer or transitioning:
		return
	
	if not swipercooldown:
		swipercooldown = true
		swipe_used = true		
		await cardswipingactivity._start_swipe()
		await get_tree().create_timer(5.0).timeout
		swipercooldown = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel"):
		if pausemenu.visible:
			pausemenu.close()
			audioOne.stream_paused = false
		elif begintut.visible:
			pass
		else:
			pausemenu.open()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "cardswipe_hitbox":
		var subwayscanner = area.get_parent()
		subwayscanner.queue_free()

func _on_swipe_done() -> void:
	cardswipingactivity.first_time = true
	audioOne.stream_paused = false
	await get_tree().create_timer(5.0).timeout
	swipe_used = false

func set_character(choice: String):
	if Globals.chosen_gender == 1:
		match choice:
			"0":
				mainchara.get_node("AnimatedSprite2D").sprite_frames = load("res://art/frames/maincharawalking0.tres")
			"1":
				mainchara.get_node("AnimatedSprite2D").sprite_frames = load("res://art/frames/maincharawalking1.tres")
			"2":
				mainchara.get_node("AnimatedSprite2D").sprite_frames = load("res://art/frames/maincharawalking2.tres")
	elif Globals.chosen_gender == 2:
		match choice:
			"0":
				mainchara.get_node("AnimatedSprite2D").sprite_frames = load("res://art/frames/maincharawoman0.tres")
			"1":
				mainchara.get_node("AnimatedSprite2D").sprite_frames = load("res://art/frames/maincharawoman1.tres")
			"2":
				mainchara.get_node("AnimatedSprite2D").sprite_frames = load("res://art/frames/maincharawoman2.tres")

func set_character_river(choice: String):
	if Globals.chosen_gender == 1:
		match choice:
			"0":
				mainchara.get_node("AnimatedSprite2D").sprite_frames = load("res://art/frames/mainchara1boat.tres")
			"1":
				mainchara.get_node("AnimatedSprite2D").sprite_frames = load("res://art/frames/mainchara2boat.tres")
			"2":
				mainchara.get_node("AnimatedSprite2D").sprite_frames = load("res://art/frames/mainchara3boat.tres")
	elif Globals.chosen_gender == 2:
		match choice:
			"0":
				mainchara.get_node("AnimatedSprite2D").sprite_frames = load("res://art/frames/mainchara1womanboat.tres")
			"1":
				mainchara.get_node("AnimatedSprite2D").sprite_frames = load("res://art/frames/mainchara2womanboat.tres")
			"2":
				mainchara.get_node("AnimatedSprite2D").sprite_frames = load("res://art/frames/mainchara3womanboat.tres")


func _on_bufferzone_body_entered(body: Node2D) -> void:
	if body.name == "mainchara":
		in_transition_buffer = true

func _on_bufferzone_body_exited(body: Node2D) -> void:
	if body.name == "mainchara":
		in_transition_buffer = false

func _on_trainconductor_contacted(conductor: Node) -> void:
	if in_transition_buffer or transitioning:
		return
	if shield_active == true:
		shield_active = false
		shieldicon.hide()
		return
	coinicon.hide()
	coins.hide()
	fevertext.hide()
	texture.hide()
	charmtexture.hide()
	points.hide()
	points_int -= (points_int / 10)
	_update_points()
	times -= times/5
	points_frozen = true
	print("points frozen")
	get_tree().paused = true
	audioEnc.play()

	if train_dialogue_ui == null:
		push_error("dialogue_ui_path is not set to a DialogueUI node")
		return
	var picked:int = await train_dialogue_ui.show_dialogue_from_profile(conductor)
	print(picked)
	if picked == 0:
		_switch_scene_to_country()
	elif picked == 1:
		_switch_scene_to_river()
	train_dialogue_ui.close_dialogue()
	continuecanvas.hide()
	coins.show()
	coinicon.show()
	points.show()
	
	get_tree().paused = false
	
	if is_instance_valid(conductor):
		conductor.queue_free()
	
	if lives <= 0:
		_game_over()
		
	if spawner.fever_active:
		print("CHECKING!")
		fevertext.show()
		texture.show()
		anim.play("fever_constant")
	else:
		pass
	if get_tree():
		await get_tree().create_timer(3.0).timeout
		points_frozen = false
		print("points unfrozen")

func _switch_scene_to_country() -> void:
	transitioning = true
	countryswitchtext.show()
	stop_audio = true
	audioOne.stop()
	trainaudio.play()
	countryswitchanim.play("fade_in")
	countryswitchtext.show()
	await countryswitchanim.animation_finished
	countryswitchanim.play("going")
	await get_tree().create_timer(5.0).timeout
	countryswitchanim.play("fade_out")
	await countryswitchanim.animation_finished
	citylayer.visible = false
	subwaylayer.visible = false
	countryblossomslayer.visible = true
	countrylayer.visible = true
	countrycollision.disabled = false
	print("Before:", mainchara.global_position)
	mainchara.global_position = subwaypoint.global_position
	print("After:", mainchara.global_position)
	countryexit.set_deferred("monitoring", true)
	countryexit.set_deferred("monitorable", true)
	enemyspawningcountry.set_deferred("monitoring", true)
	enemyspawningcountry.set_deferred("monitorable", true)
	var cam := get_viewport().get_camera_2d()
	trainaudio.stop()
	stop_audio = false
	audioOne.play()
	cam.global_position = subwaypoint.global_position
	countryswitchtext.hide()

	for l in countrylayer.get_children():
		if l is ParallaxLayer:
			l.motion_offset = Vector2.ZERO
	_reset_player_position()
	for child in characters.get_children():
		if child != mainchara:
			child.queue_free()
	for child in events.get_children():
		child.queue_free()
	for child in envir.get_children():
		child.queue_free()
	for child in cardswipers.get_children():
		child.queue_free()
	for child in trainconductors.get_children():
		child.queue_free()
	transitioning = false

func _on_country_exit_triggered():
	if exiting_country:
		return
	transitioning = true
	stop_audio = true
	audioOne.stop()
	trainaudio.play()
	countryswitchanim.play("fade_in")
	countryswitchtext.show()
	await countryswitchanim.animation_finished
	countryswitchanim.play("going")
	await get_tree().create_timer(5.0).timeout
	from_country = true
	countrylayer.visible = false
	countryblossomslayer.visible = false
	subwaylayer.visible = true
	citylayer.visible = false
	countrycollision.disabled = true
	_switch_scene_to_subway()
	countryswitchanim.play("fade_out")
	await countryswitchanim.animation_finished
	exiting_country = true
	countryexit.set_deferred("monitoring", false)
	countryexit.set_deferred("monitorable", false)
	enemyspawningcountry.set_deferred("monitoring", false)
	enemyspawningcountry.set_deferred("monitorable", false)
	_reset_player_position()
	trainaudio.stop()
	stop_audio = false
	audioOne.play()
	exiting_country = false
	transitioning = false
	countryswitchtext.hide()
	
func _on_countryexit_body_entered(body: Node2D) -> void:
	if body != mainchara:
		return
	if countrylayer.visible == false:
		return
	if not exiting_country:
		_on_country_exit_triggered()

func _on_bufferzone_country_body_entered(body: Node2D) -> void:
	if body.name == "mainchara":
		in_transition_buffer = true

func _on_bufferzone_country_body_exited(body: Node2D) -> void:
	if body.name == "mainchara":
		in_transition_buffer = false

func _on_animal_contacted(animal: Node2D):
	if shield_active == true:
		shield_active = false
		shieldicon.hide()
		return
	print("ANIMAL HAS BEEN CONTACTED!!!")
	get_tree().paused = true
	audioEnc.play()
	await get_tree().create_timer(2.0).timeout
	var p = animal.get("profile") if animal else null
	if p.display_name == "Golden Retriever":
		print("GOLDEN RETRIEVER")
		dogactivity.dogtype = 0
	elif p.display_name == "Super Dog":
		print("Super DOG")
		dogactivity.dogtype = 1
	elif p.display_name == "Labrador":
		print("LABRADOR")
		dogactivity.dogtype = 2
	dogactivity.artificial_ready()
	await dogactivity.activity_ended
	animal.queue_free()
	
func _on_dog_activity_ended():
	continuecanvas.show()
	continuetimer.play("continuetimer")
	await continuetimer.animation_finished
	continuecanvas.hide()
	get_tree().paused = false
	audioOne.stream_paused = false

func _on_enemyspawnchange_body_entered(body: Node2D) -> void:
	if body.name == "mainchara":
		return
	if body.get_parent() == characters:
		body.queue_free()
	if body.get_parent() == animals:
		body.queue_free()

func _on_riverexit_body_entered(body: Node2D) -> void:
	if body != mainchara:
		return
	if river.visible == false:
		return
	if not exiting_river:
		_on_river_exit_triggered()

func _switch_scene_to_river() -> void:
	transitioning = true
	countryswitchtext.show()
	stop_audio = true
	audioOne.stop()
	trainaudio.play()
	countryswitchanim.play("fade_in")
	countryswitchtext.show()
	await countryswitchanim.animation_finished
	countryswitchanim.play("going")
	await get_tree().create_timer(5.0).timeout
	countryswitchanim.play("fade_out")
	await countryswitchanim.animation_finished
	set_character_river(Globals.chosen_character)
	citylayer.visible = false
	subwaylayer.visible = false
	countrylayer.visible = false
	yanagawatrees.visible = true
	river.visible = true
	print("Before:", mainchara.global_position)
	mainchara.global_position = subwaypoint.global_position
	print("After:", mainchara.global_position)
	riverexit.set_deferred("monitoring", true)
	riverexit.set_deferred("monitorable", true)
	enemyspawningriver.set_deferred("monitoring", true)
	enemyspawningriver.set_deferred("monitorable", true)
	var cam := get_viewport().get_camera_2d()
	trainaudio.stop()
	stop_audio = false
	audioOne.play()
	cam.global_position = subwaypoint.global_position
	countryswitchtext.hide()

	for l in river.get_children():
		if l is ParallaxLayer:
			l.motion_offset = Vector2.ZERO
	_reset_player_position()
	for child in characters.get_children():
		if child != mainchara:
			child.queue_free()
	for child in events.get_children():
		child.queue_free()
	for child in envir.get_children():
		child.queue_free()
	for child in cardswipers.get_children():
		child.queue_free()
	for child in trainconductors.get_children():
		child.queue_free()
	for child in boats.get_children():
		child.queue_free()
	transitioning = false

func _on_river_exit_triggered():
	print("yes it's", countryexit.monitorable)
	print("yes it's", countryexit.monitoring)
	if exiting_river:
		print("not going in again")
		return
	transitioning = true
	stop_audio = true
	audioOne.stop()
	trainaudio.play()
	set_character(Globals.chosen_character)
	countryswitchanim.play("fade_in")
	countryswitchtext.show()
	await countryswitchanim.animation_finished
	countryswitchanim.play("going")
	await get_tree().create_timer(5.0).timeout
	exiting_river = true
	subwaylayer.visible = true
	from_river = true
	river.visible = false
	yanagawatrees.visible = false
	citylayer.visible = false
	subwaylayer.visible = true
	_switch_scene_to_subway()
	countryswitchanim.play("fade_out")
	await countryswitchanim.animation_finished
	riverexit.set_deferred("monitoring", false)
	riverexit.set_deferred("monitorable", false)
	enemyspawningriver.set_deferred("monitoring", false)
	enemyspawningriver.set_deferred("monitorable", false)
	_reset_player_position()
	trainaudio.stop()
	stop_audio = false
	audioOne.play()
	exiting_river = false
	transitioning = false
	countryswitchtext.hide()

func _on_boat_contacted(boat: Node) -> void:
	if shield_active == true:
		shield_active = false
		shieldicon.hide()
		return
	get_tree().paused = true
	audioEnc.play()
	await get_tree().create_timer(1.0).timeout
	balanceboatactivity.artificial_ready()
	balanceboatactivity.process_mode = Node.PROCESS_MODE_ALWAYS

func _on_boat_activity_finished():
	continuecanvas.show()
	continuetimer.play("continuetimer")
	await continuetimer.animation_finished
	continuecanvas.hide()
	get_tree().paused = false
	audioOne.stream_paused = false
