extends CanvasLayer

@onready var boat = $boat
@onready var player = $boat/mainchara
@onready var passengers = $passengers
@onready var tilt_meter = $ProgressBar
@onready var wave_meter = $waveprogressbar
@onready var countdownlabel = $Label
@onready var clearlabel = $Clear
@onready var anim = $AnimationPlayer
@onready var wavesanim = $waves
@onready var instructionslabel = $Label2

var tilt := 0.0
var tilt_velocity := 0.0
var max_tilt := 25.0
var game_over := false

var wave_intensity := 0.5
var wave_growth_rate := 0.2
var max_wave_intensity := 5.0

var survival := 20.0
var elapsed_time := 0.0

func _ready() -> void:
	for p in passengers.get_children():
		p.set_meta("base_x", p.position.x)
	countdownlabel.hide()
	clearlabel.hide()
	instructionslabel.hide()
	artificial_ready()

func artificial_ready() -> void:
	clearlabel.hide()
	countdownlabel.show()
	instructionslabel.show()
	wavesanim.play("default")
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true

func _process(delta):
	if game_over:
		return
	
	elapsed_time += delta
	var remaining = survival - elapsed_time
	countdownlabel.text = str(round(remaining))
	
	if elapsed_time >= survival:
		_win_game()
		return
	
	var control_force := 6.0
	if Input.is_action_pressed("left"):
		tilt_velocity -= control_force * delta
	elif Input.is_action_pressed("right"):
		tilt_velocity += control_force * delta
	
	var wave_shift = randf_range(-1.5, 1.5)
	tilt_velocity += wave_shift * delta
	
	if randf() < 0.005 * wave_intensity:
		tilt_velocity += randf_range(-1.5, 1.5)
	
	tilt_velocity = clamp(tilt_velocity, -5, 5)
	tilt += tilt_velocity
	tilt_velocity *= 0.97
	tilt = clamp(tilt, -max_tilt, max_tilt)
	
	boat.rotation_degrees = tilt + sin(Time.get_ticks_msec() / 500.0) * 0.2
	tilt_meter.value = abs(tilt)
	
	for p in passengers.get_children():
		if not p.has_meta("base_pos"):
			p.set_meta("base_pos", p.position)
		var base_pos: Vector2 = p.get_meta("base_pos")
		
		var tilt = boat.rotation
		var max_tilt_radians = deg_to_rad(max_tilt)
		
		var slide_strength_x = 100.0
		var slide_strength_y = 95.0
		var gravity_pull = 0.25
		
		var slide_ratio =  clamp(tilt / max_tilt_radians, -1.0, 1.0)
		var slide_x = slide_ratio * slide_strength_x
		
		var downhill = Vector2(0, 1).rotated(tilt).normalized()
		var slide_y = downhill.y * abs(slide_ratio) * slide_strength_y
		
		var target_pos = base_pos + Vector2(slide_x, slide_y)

		p.position = p.position.lerp(target_pos, gravity_pull)
		p.rotation = -boat.rotation / 2.0
	if not game_over:
		wave_intensity = min(wave_intensity + wave_growth_rate * delta, max_wave_intensity)
		wave_meter.value = (wave_intensity / max_wave_intensity) * 100
	
	if abs(tilt) >= max_tilt:
		game_over = true
		_game_over()

		
func _game_over():
	print("Boat donedoneonde")
	$AudioStreamPlayer.play()
	await get_tree().create_timer(1.5).timeout
	get_tree().reload_current_scene()

func _win_game():
	instructionslabel.hide()
	countdownlabel.hide()
	clearlabel.show()
	anim.play("clear")
	await anim.animation_finished
	print("wonwon won won won")
	get_tree().paused = false
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED
