extends CharacterBody2D

@export var speed: float = 120.0
@export var dir: Vector2 = Vector2.LEFT  # we'll override later

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	# Make sure it's visible even if someone set alpha to 0 somewhere
	modulate.a = 1.0
	sprite.visible = true

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
