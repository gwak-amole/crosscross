extends Button

@export var characterselectpath : NodePath

@onready var anim := $AnimatedSprite2D
@onready var charselect := get_node(characterselectpath)

var global_anim_time := 0.0
var is_selected := false
var is_stay_focused := false

func _ready():
	update_visual()

func _process(delta):
	global_anim_time += delta
	_sync_animation_frame()

func _on_pressed():
	print("pressed")
	self.is_stay_focused = true
	if self.name == "Button":
		charselect._on_character_button_pressed("0")
	elif self.name == "Button2":
		charselect._on_character_button_pressed("1")
	elif self.name == "Button3":
		charselect._on_character_button_pressed("2")
	for sibling in get_parent().get_children():
		if sibling is Button and sibling != self:
			sibling.is_selected = false
			sibling.update_visual()
	is_selected = true
	update_visual()
	
func _on_focused():
	anim.play("focused")

func _on_unfocused():
	if self.is_stay_focused:
		pass
	else:
		anim.play("default")

func update_visual():
	if is_selected:
		add_theme_stylebox_override("normal", get_theme_stylebox("focus", "Button"))
		anim.play("focused")
		self.is_stay_focused = true
	else:
		remove_theme_stylebox_override("normal")
		self.is_stay_focused = false
		anim.play("default")

func _sync_animation_frame() -> void:
	var anim_name = "focused" if is_stay_focused else "default"
	if anim.sprite_frames.has_animation(anim_name):
		var total_frames = anim.sprite_frames.get_frame_count(anim_name)
		if total_frames > 0:
			var frame = int(fmod(global_anim_time * anim.speed_scale, float(total_frames)))
			anim.play(anim_name)
			anim.frame = frame
