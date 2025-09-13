extends Node2D

signal coin_contacted(event: Node)
signal shield_contacted(event: Node)

@export var profile: EventProfile
@export var profile_array : Array[EventProfile] = []
@onready var anim: AnimatedSprite2D = $CharacterBody2D/AnimatedSprite2D
@onready var onscreen: VisibleOnScreenNotifier2D = $CharacterBody2D/VisibleOnScreenNotifier2D

func _ready():
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	if onscreen and not onscreen.screen_exited.is_connected(_on_screen_exited):
		onscreen.screen_exited.connect(_on_screen_exited)
	if profile and profile.sprite_frames:
		anim.sprite_frames = profile.sprite_frames
		anim.play("default")

func _on_screen_exited() -> void:
	queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name != "player_hitbox": return
	
	if self.profile == profile_array[0]:
		emit_signal("coin_contacted", self)
	if self.profile == profile_array[1]:
		emit_signal("shield_contacted", self)
	queue_free()
