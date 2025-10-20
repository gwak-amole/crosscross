extends Node2D

signal fever_done(tf: bool)
@export var train_scene: PackedScene
@export var controller_path: NodePath
@export var characters_path: NodePath
@export var mainchara_path: NodePath
@export var eventpath : NodePath
@export var subwaylayerpath : NodePath
@export var start_spawn_every: float = 5
@export var min_spawn_every:= 4
@export var max_on_screen: int = 1
@export var half_life_seconds := 45.0
@export var new_time_elapsed := elapsed

@export var lanes_x: PackedFloat32Array = [190.0, 390.0]
@export var x_spawn_left: float = 200
@export var x_spawn_right: float = 350
@export var spawn_margin_y: float = 20.0

@onready var controller := get_node(controller_path)
@onready var characters := get_node_or_null(characters_path)
@onready var eventspawner := get_node_or_null(eventpath)
@onready var mainchara := get_node(mainchara_path)
@onready var subwaylayer := get_node(subwaylayerpath)
@onready var timer: Timer = $Timer
var rng := RandomNumberGenerator.new()
var elapsed := 0.0
var fever_active := false
var old_speed : float = 0
var old_maincharaspeed : float = 0
var puddle_cooldown := false
var subway_in := false

func _ready() -> void:
	if train_scene == null or characters == null:
		push_error("Spawner miswired: set enemy_scene and characters_path in Inspector.")
		return
	if not controller.fever.is_connected(_on_fever_started):
		controller.fever.connect(_on_fever_started)
	if not controller.fever_end.is_connected(_on_fever_ended):
		controller.fever_end.connect(_on_fever_ended)
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
	if subwaylayer.visible == false:
		return
	if controller.transitioning:
		return
	await get_tree().create_timer(0.5).timeout
	var e := train_scene.instantiate()
	characters.add_child(e)
	
	var ctrl := get_node(controller_path)
	e.contacted.connect(Callable(ctrl, "_on_trainconductor_contacted"))
	print("TRAIN CONDUCTOR CONTACTED IS IN SPAWNER")
	var cam := get_viewport().get_camera_2d()
	var view := get_viewport_rect().size
	var top := cam.global_position.y - (view.y * 0.5)
	var spawn_lanes = lanes_x
	if subway_in:
		spawn_lanes = [160.0, 420.0]
	var x: float = spawn_lanes[rng.randi_range(0, spawn_lanes.size() - 1)]
	var y: float = top - spawn_margin_y    
	e.global_position = Vector2(x, y)


func _on_fever_started() -> void:
	if fever_active:
		return
	fever_active = true
	print("fever is active")
	max_on_screen = 1
	min_spawn_every = 4
	start_spawn_every = 5
	print("yes, here too")
	
func _on_fever_ended() -> void:
	max_on_screen = 1
	min_spawn_every = 4
	start_spawn_every = 5
	timer.wait_time = min_spawn_every
	timer.start()
	print("fever inactive")
	fever_active = false
