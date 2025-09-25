extends CharacterBody2D

signal entry_contacted
signal subwaysin
signal subwaysout
@export var profile_array : Array[SubwayEntryProfile]
@export var profile: SubwayEntryProfile
@export var sprite_path : NodePath
@onready var onscreen: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var sprite := get_node(sprite_path)

func _ready() -> void:
	print('we exist')
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	if onscreen and not onscreen.screen_exited.is_connected(_on_screen_exited):
		onscreen.screen_exited.connect(_on_screen_exited)
	if profile and profile.texture:
		sprite.texture = profile.texture
		sprite.z_index = 100
		sprite.show()

	
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name != "player_hitbox":
		return
	print("we contacted")
	emit_signal("entry_contacted", self)
	await get_tree().create_timer(0.5).timeout
	emit_signal("subwaysout")
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("SUBWAY'S OUT AUTO")
	emit_signal("subwaysout")
	queue_free()

func _on_screen_exited() -> void:
	print("SUBWAY IS OUT MANUALLY")
	emit_signal("subwaysout")
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	emit_signal("subwaysin")


func _on_forenemies_area_entered(area: Area2D) -> void:
	if area.name != "enemy_hitbox":
		var enemy = area.get_parent()
		enemy.queue_free()
