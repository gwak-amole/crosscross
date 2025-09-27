extends CanvasLayer

signal done
@onready var bar := $Control/Panel/ProgressBar
@onready var label := $Control/Panel/Label
@onready var card := $card
@onready var anim := $Control/Panel/AnimationPlayer
@onready var audiocorrect := $correct
@onready var audiowrong := $wrong

var filling := false
var target_zone = Vector2(70, 80)
var swipe_done = false
var start_pos = Vector2(300, 400)
var end_pos = Vector2(850, 400)
var first_time = true

func _ready():
	bar.value = 0
	bar.min_value = 0
	bar.max_value = 100
	card.position = start_pos
	label.text = "Swipe your card! (Hold SPACE)"
	first_time = true
	hide()

func _start_swipe():
	swipe_done = false
	get_tree().paused = true
	bar.value = 0
	card.position = start_pos
	show()
	
	if first_time:
		label.text = "Swipe your card! (Hold SPACE)"
		anim.play("appear")
		await anim.animation_finished
	else:
		pass
	
func _process(delta):
	if filling and not swipe_done:
		bar.value = clamp(bar.value + delta * 50, 0, 100)
		var t = bar.value / bar.max_value
		card.position = start_pos.lerp(end_pos, t)
		
func _unhandled_input(event):
	if swipe_done:
		return
	if visible:
		if event.is_action_pressed("ui_accept"):
			filling = true
			
		if event.is_action_released("ui_accept"):
			filling = false
			_check_swipe()
		
func _check_swipe():
	if bar.value >= target_zone.x and bar.value <= target_zone.y:
		label.text = "Success!"
		audiocorrect.play()
		emit_signal("swipe_success")
		swipe_done = true
		await get_tree().create_timer(1.0).timeout
		anim.play("hide")
		await anim.animation_finished
		_close_swipe()
	else:
		label.text = "Failed! Try again."
		audiowrong.play()
		swipe_done = false
		first_time = false
		_start_swipe()
	
func _close_swipe() -> void:
	hide()
	emit_signal("done")
	get_tree().paused = false
	
