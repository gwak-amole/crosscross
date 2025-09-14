extends Camera2D
@export var start_scroll_speed := 30
@export var max_scroll_speed := 200.0
@export var growth_per_sec: float = 0.02

@export var parallax_path: NodePath
@export var characters_path: NodePath

var speed: float
@onready var pbg := get_node_or_null(parallax_path)
@onready var characters := get_node_or_null(characters_path)

func _ready() -> void:
	speed = start_scroll_speed
	if speed > max_scroll_speed:
		speed = max_scroll_speed

func _process(delta: float) -> void:
	speed *= pow(1.0 + growth_per_sec, delta)
	global_position.y -= speed * delta
	if speed > max_scroll_speed:
		speed = max_scroll_speed
	
	if pbg:
		pbg.scroll_offset.y -= speed * delta
		
	if characters:
		characters.position.y += speed * delta
