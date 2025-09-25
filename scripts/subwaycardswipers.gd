extends Sprite2D

signal swiper_contacted

@onready var onscreen: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	if onscreen and not onscreen.screen_exited.is_connected(_on_screen_exited):
		onscreen.screen_exited.connect(_on_screen_exited)
		self.z_index = 0

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name != "player_hitbox": return
	emit_signal("swiper_contacted", self)
	print("signal swiper emitted")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_screen_exited() -> void:
	queue_free()
