extends Node2D

@export var cardswiper_scene: PackedScene
@export var controller_path: NodePath
@export var characters_path: NodePath
@export var subwaylayerpath: NodePath
@export var maincharapath: NodePath
@export var start_spawn_every: float = 15
@export var min_spawn_every := 7
@export var max_on_screen: int = 2
@export var half_life_seconds := 45.0
@export var new_time_elapsed := elapsed

@export var x_spawn_left: float = 200
@export var x_spawn_right: float = 350
@export var spawn_margin_y: float = 20.0

@onready var controller := get_node(controller_path)
@onready var characters := get_node_or_null(characters_path)
@onready var subwaylayer := get_node_or_null(subwaylayerpath)
@onready var mainchara := get_node_or_null(maincharapath)
@onready var timer: Timer = $Timer
var rng := RandomNumberGenerator.new()
var chance : int = 0
var thechance := 0
var elapsed := 0.0
var subway_in : bool = false

func _ready() -> void:
	if cardswiper_scene == null or characters == null:
		push_error("Spawner miswired: set enemy_scene and characters_path in Inspector.")
		return
	rng.randomize()
	timer.one_shot = false
	timer.wait_time = start_spawn_every
	if not timer.timeout.is_connected(_on_spawn_tick):
		timer.timeout.connect(_on_spawn_tick)
	timer.start()

func _process(delta):
	elapsed += delta

func _on_spawn_tick() -> void:
	if characters.get_child_count() >= max_on_screen:
		return
	_spawn_one()
	var k := pow(0.5, elapsed / max(half_life_seconds, 0.001))
	var next := min_spawn_every + (start_spawn_every - min_spawn_every) * k
	if new_time_elapsed > 1:
		new_time_elapsed = elapsed - floor(elapsed)
	if new_time_elapsed >= 1:
		max_on_screen += 1
		if spawn_margin_y >= 0.3:
			spawn_margin_y -= 0.2
		new_time_elapsed -= 1
	timer.wait_time = next
	timer.start()

func _spawn_one() -> void:
	if subwaylayer.visible:
		print("SPAWNING ALL")
		var e := cardswiper_scene.instantiate()
		var f := cardswiper_scene.instantiate()
		var g := cardswiper_scene.instantiate()
		var ctrl := get_node(controller_path)
		print(ctrl)
		e.swiper_contacted.connect(Callable(ctrl, "_on_swiper_contacted"))
		f.swiper_contacted.connect(Callable(ctrl, "_on_swiper_contacted"))
		g.swiper_contacted.connect(Callable(ctrl, "_on_swiper_contacted"))

		print("[SPAWNER] hooked swiper signal")
		
		var cam := get_viewport().get_camera_2d()
		var view := get_viewport_rect().size
		var top := cam.global_position.y - (view.y * 0.5) 

		var y: float = top - spawn_margin_y    
		e.global_position = Vector2(125.0, y)
		f.global_position = Vector2(295.0, y)
		g.global_position = Vector2(457.0, y)
		characters.add_child(e)
		characters.add_child(f)
		characters.add_child(g)
		print("Spawned at: ", e.global_position)
		print("Spawned at: ", f.global_position)
		print("Spawned at: ", g.global_position)
		print(mainchara.global_position)
	
func _start_fever() -> void:
	max_on_screen = 0

func _end_fever() -> void:
	max_on_screen = 2
