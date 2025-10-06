extends CanvasLayer

signal activity_ended
@onready var calm_bar: ProgressBar = $ProgressBar
@onready var anim: AnimationPlayer = $AnimationPlayer2
@onready var heartanim: AnimationPlayer = $AnimationPlayer
@onready var total_anim: AnimationPlayer = $totalanim
@onready var dog_sprite: TextureRect = $TextureRect
@onready var label: Label = $Label

var calm_level := 0
var timing_window := 0.1
var beat_timer := 0.0
var beat_interval := 1.2
var can_tap := false
var can_tap_ult := false

func _ready():
	visible = false
	self.process_mode = Node.PROCESS_MODE_DISABLED

func artificial_ready(): 
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	calm_bar.value = 0
	calm_level = 0
	beat_timer = 0.0
	can_tap = true
	label.text = ""
	heartanim.stop()
	anim.play("normal")
	total_anim.play("fade_in")
	visible = true
	await total_anim.animation_finished
	await get_tree().create_timer(0.05).timeout
	heartanim.play("heartbeat")
	can_tap_ult = true

func _process(delta):
	beat_timer += delta
	if beat_timer > beat_interval and can_tap_ult:
		beat_timer = 0.0
		can_tap = true
		anim.play("heartbeat")

func _input(event):
	if event.is_action_pressed("ui_accept") and can_tap:
		var distance_from_beat = abs(beat_timer - beat_interval / 2)
		var perfect_window = 0.1
		var good_window  = 0.25
		if distance_from_beat <= perfect_window:
			label.text = "Perfect!"
			calm_dog()
		elif distance_from_beat <= good_window:
			label.text = "Close!"
			calm_dog()
			calm_level -= 2
		else:
			label.text = "Miss!"
			disturb_dog()
		can_tap = false
		
func calm_dog():
	calm_level += 10
	calm_bar.value = calm_level
	dog_sprite.modulate = Color(1, 1, 1)
	if calm_level >= 100:
		end_scene(true)

func disturb_dog():
	calm_level = max(0, calm_level - 5)
	calm_bar.value = calm_level
	dog_sprite.modulate = Color(1, 0.8, 0.8)
	anim.play("bark")

func end_scene(success: bool):
	anim.play("calm")
	await anim.animation_finished
	if success:
		label.text = "The dog has calmed down."
	heartanim.stop()
	can_tap_ult = false
	can_tap = false
	visible = false
	emit_signal("activity_ended")
	self.process_mode = Node.PROCESS_MODE_DISABLED
