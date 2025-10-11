extends CanvasLayer

@onready var boat = $boat
@onready var player = $boat/mainchara
@onready var passengers = $boat/passengers
@onready var tilt_meter = $ProgressBar

var tilt := 0.0
var tilt_velocity := 0.0
var max_tilt := 25.0
var game_over := false

func _process(delta):
	if game_over:
		return
	
	var shift = randf_range(-1.5, 1.5)
	tilt_velocity += shift * delta
	tilt += tilt_velocity
	
	tilt_velocity *= 0.95
	tilt = clamp(tilt, -max_tilt, max_tilt)
	
	boat.rotation_degrees = tilt
	tilt_meter.value = abs(tilt)
	
	boat.rotation_degrees += sin(Time.get_ticks_msec() / 500.0) * 0.05
	
	if abs(tilt) >= max_tilt:
		game_over = true
		_game_over()
		
func _input(event):
	if event.is_action_pressed("left"):
		tilt_velocity += 2
	elif event.is_action_pressed("right"):
		tilt_velocity -= 2

func _game_over():
	print("Boat donedoneonde")
	$AudioStreamPlayer.play()
	await get_tree().create_timer(1.5).timeout
	get_tree().reload_current_scene()
