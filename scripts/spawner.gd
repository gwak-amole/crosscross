extends Node2D

@export var profiles: Array[EnemyProfile] = []
@export var enemy_scene: PackedScene
@export var controller_path: NodePath
@export var characters_path: NodePath
@export var start_spawn_every: float = 1.2
@export var min_spawn_every:= 0.3
@export var max_on_screen: int = 8
@export var half_life_seconds := 45.0
@export var new_time_elapsed := elapsed

# Put Y values you can actually see with your current camera/zoom:
@export var lanes_x: PackedFloat32Array = [160.0, 220.0, 280.0, 360.0, 420.0]
@export var x_spawn_left: float = 200
@export var x_spawn_right: float = 350
@export var spawn_margin_y: float = 20.0

@onready var controller := get_node(controller_path)
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
		new_time_elapsed - 1
	timer.wait_time = next
	timer.start()

func _spawn_one() -> void:
	var e := enemy_scene.instantiate()
	if profiles.size() > 0:
		e.profile = profiles[rng.randi_range(0, profiles.size()-1)]
	characters.add_child(e)
	
	var ctrl := get_node(controller_path)
	e.contacted.connect(Callable(ctrl, "_on_enemy_contacted"))
	print("[SPAWNER] hooked enemy signal")
	
	if controller and controller.has_method("hook_enemy"):
		controller.hook_enemy(e)
	
	var cam := get_viewport().get_camera_2d()
	var view := get_viewport_rect().size
	var top := cam.global_position.y - (view.y * 0.5)  # top edge of screen in world space

	var x: float = lanes_x[rng.randi_range(0, lanes_x.size() - 1)]
	var y: float = top - spawn_margin_y    
	e.global_position = Vector2(x, y)

	print("Spawned at: ", e.global_position)
