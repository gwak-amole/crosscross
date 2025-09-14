extends CharacterBody2D

signal puddle_contacted
@export var profile_array : Array[EnvMishapProfile]
@export var profile: EnvMishapProfile
@export var sprite_path : NodePath

@onready var onscreen: VisibleOnScreenNotifier2D = $CharacterBody2D/VisibleOnScreenNotifier2D
@onready var sprite := get_node(sprite_path)

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	if onscreen and not onscreen.screen_exited.is_connected(_on_screen_exited):
		onscreen.screen_exited.connect(_on_screen_exited)
	if profile and profile.texture:
		sprite.texture = profile.texture
		sprite.z_index = 100
		sprite.show()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name != "player_hitbox": return
	emit_signal("puddle_contacted", self)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_screen_exited() -> void:
	queue_free()
