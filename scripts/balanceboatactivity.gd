extends CanvasLayer

signal activity_ended
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
@onready var totalanim = $totalanim
@onready var continuecanvas = $continuetimer
@onready var continuetimeranim = $continuetimer/continuetimeranim
@onready var gameaudio = $gamemusic

var first_time

var tilt := 0.0
var tilt_velocity := 0.0
var max_tilt := 25.0
var game_over := false

var wave_intensity := 0.5
var wave_growth_rate := 0.2
var max_wave_intensity := 5.0

var survival := 15.0
var elapsed_time := 0.0
var boattype : int = -1

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	self.hide()
	for p in passengers.get_children():
		for child in p.get_children():
			child.set_meta("base_x", p.position.x)
		p.hide()
	countdownlabel.hide()
	clearlabel.hide()
	instructionslabel.hide()
	first_time = true

func artificial_ready() -> void:
	self.show()
	elapsed_time = 0.0
	for p in passengers.get_children():
		p.hide()
	if boattype == 0:
		$passengers/highschoolers.show()
	elif boattype == 1:
		$passengers/gyarus.show()
	elif boattype == 2:
		$passengers/ramenchefs.show()
	if first_time:
		totalanim.play("fade_in")
		await totalanim.animation_finished
	first_time = false
	game_over = false
	tilt = 0.0
	tilt_velocity = 0.0
	wave_intensity = 0.5
	countdownlabel.hide()
	clearlabel.hide()
	
	for p in passengers.get_children():
		if p.has_meta("base_pos"):
			p.position = p.get_meta("base_pos")
		p.rotation = 0
	
	boat.rotation = 0
	tilt_meter.value = 0
	wave_meter.value = 0
	clearlabel.hide()
	countdownlabel.show()
	instructionslabel.show()
	wavesanim.play("default")
	continuecanvas.show()
	continuetimeranim.play("continuetimer")
	await continuetimeranim.animation_finished
	continuecanvas.hide()
	gameaudio.play()
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta):
	if totalanim.is_playing() or continuetimeranim.is_playing():
		return
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
	if not game_over:
		wave_intensity = min(wave_intensity + wave_growth_rate * delta, max_wave_intensity)
		wave_meter.value = (wave_intensity / max_wave_intensity) * 100
	
	if abs(tilt) >= max_tilt:
		game_over = true
		_game_over()

		
func _game_over():
	gameaudio.stop()
	print("Boat donedoneonde")
	$AudioStreamPlayer.play()
	await get_tree().create_timer(1.5).timeout
	reset_game()

func _win_game():
	instructionslabel.hide()
	countdownlabel.hide()
	clearlabel.show()
	gameaudio.stop()
	anim.play("clear")
	await anim.animation_finished
	print("wonwon won won won")
	for p in passengers.get_children():
		p.hide()
	get_tree().paused = false
	hide()
	emit_signal("activity_ended")
	process_mode = Node.PROCESS_MODE_DISABLED

func reset_game():
	game_over = false
	tilt = 0.0
	tilt_velocity = 0.0
	elapsed_time = 0.0
	wave_intensity = 0.5
	countdownlabel.hide()
	clearlabel.hide()
	
	for p in passengers.get_children():
		if p.has_meta("base_pos"):
			p.position = p.get_meta("base_pos")
		p.rotation = 0
	
	boat.rotation = 0
	tilt_meter.value = 0
	wave_meter.value = 0
	artificial_ready()
