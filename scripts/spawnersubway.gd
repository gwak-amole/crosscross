extends Node2D

signal fever_done(tf: bool)
@export var profiles: Array[EnemyProfile] = []
@export var enemy_scene: PackedScene
@export var characters_path: NodePath
@export var half_life_seconds := 45.0
@export var start_spawn_every: float = 1.2
@export var min_spawn_every:= 0.3
@export var max_on_screen: int = 8
@export var lanes_x: PackedFloat32Array = [160.0, 220.0, 280.0, 360.0, 420.0]
@export var spawn_margin_y: float = 20.0
@export var total_enemies: int = 20

@onready var characters := get_node_or_null(characters_path)
@onready var timer: Timer = $Timer
var rng := RandomNumberGenerator.new()
var elapsed := 0.0

func _ready() -> void:
	if enemy_scene == null or characters == null:
		push_error("Spawner miswired: set enemy_scene and characters_path in Inspector.")
		return
	rng.randomize()
	timer.one_shot = false
	timer.wait_time = start_spawn_every
	timer.timeout.connect(_on_spawn_tick)
	timer.start()

func _process(delta):
	elapsed += delta

func _on_spawn_tick() -> void:
	if characters.get_child_count() >= max_on_screen:
		return
	_spawn_one()
	var k := pow(0.5, elapsed / 30.0)
	var next := min_spawn_every + (start_spawn_every - min_spawn_every) * k
	timer.wait_time = next
	timer.start()

func _spawn_one() -> void:
	var e := enemy_scene.instantiate()
	if profiles.size() > 0:
		e.profile = profiles[rng.randi_range(0, profiles.size()-1)]
	characters.add_child(e)
	
	Globals.active_enemies.append(e)
	e.tree_exited.connect(func():
		Globals.active_enemies.erase(e))
	
	var cam := get_viewport().get_camera_2d()
	var view := get_viewport_rect().size
	var top := cam.global_position.y - (view.y * 0.5)

	var x: float = lanes_x[rng.randi_range(0, lanes_x.size() - 1)]
	var y: float = top - spawn_margin_y    
	e.global_position = Vector2(x, y)
