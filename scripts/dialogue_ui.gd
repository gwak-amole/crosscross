extends CanvasLayer
signal choice_made(idx: int)
signal branch_chosen(idx: int)
signal charm_used
@export var audio_path : NodePath
@export var spawnerpath : NodePath
@export var animpath : NodePath
@export var charmpath : NodePath
@export var controllerpath : NodePath
@export var tutanimpath : NodePath
@export var tutlabelpath : NodePath
@export var subwaylayerpath : NodePath
@export var countrylayerpath : NodePath
@export var subwayanimationpath : NodePath
@export var citylayerpath : NodePath

@onready var panel := $Panel
@onready var art : Node = $Panel/Art
@onready var text := $Panel/Overlay/Text
@onready var choices_box := $Panel/Overlay/Buttons
@onready var rps_choices_box := $Panel/Overlay/rpsbuttons
@onready var tutorial := $Panel/Overlay/tutorial
@onready var audio := get_node(audio_path)
@onready var spawner := get_node(spawnerpath)
@onready var anim := get_node(animpath)
@onready var charm := get_node(charmpath)
@onready var controller := get_node(controllerpath)
@onready var tutanim := get_node(tutanimpath)
@onready var tutlabel := get_node(tutlabelpath)
@onready var subwaylayer := get_node(subwaylayerpath)
@onready var subwayanim := get_node(subwayanimationpath)
@onready var countrylayer := get_node(countrylayerpath)
@onready var citylayer := get_node(citylayerpath)

var dlg_scene: Node = null
var cor_idx : int
var rng = RandomNumberGenerator.new()
var rand: int
var thecharm : bool = false
var tutorial_wanted : bool = false
var again_tutorial_wanted : bool = false
var is_rps_mode : bool = false
var enemy_move : int = -1
var charm_override : bool = false
var is_delinq : bool = false
var delinq_success = false
var is_photoo = false

func _ready() -> void:
	visible = false
	rps_choices_box.hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	if charm and charm is TextureButton:
		if not charm.pressed.is_connected(_on_charm_pressed):
			charm.pressed.connect(_on_charm_pressed)
	else:
		push_error("Charm button not found haiya")
	if again_tutorial_wanted == false:
		var yes: bool = await controller.tutorial
		tutorial_wanted = yes
	else:
		tutorial_wanted = false
	for i in range(rps_choices_box.get_child_count()):
		var btn = rps_choices_box.get_child(i)
		if btn is TextureButton:
			if not btn.pressed.is_connected(_on_rps_choice_pressed):
				btn.pressed.connect(Callable(self, "_on_rps_choice_pressed").bind(i))
	for btn in choices_box.get_children():
		if btn is TextureButton:
			btn.focus_mode = Control.FOCUS_ALL
			btn.mouse_filter = Control.MOUSE_FILTER_IGNORE

func show_dialogue_from_profile(p: EnemyProfile) -> int:
	visible = false
	panel.hide()
	choices_box.hide()
	text.hide()
	tutlabel.hide()
	rps_choices_box.hide()
	choices_box.PROCESS_MODE_DISABLED
	if is_instance_valid(dlg_scene):
		dlg_scene.queue_free()
	
	dlg_scene = p.dialogue_scene.instantiate()
	dlg_scene.process_mode = Node.PROCESS_MODE_ALWAYS
	panel.add_child(dlg_scene)
	if p.is_delinq == true:
		is_delinq = true
	else:
		is_delinq = false
	if p.is_photo:
		is_photoo = true
	else:
		is_photoo = false
	var ap = dlg_scene.get_node_or_null("AnimationPlayer")
	if ap:
		await get_tree().create_timer(1.5, true).timeout
		print("playing animations")
		if citylayer.visible:
			if ap.has_animation("appear"):
				ap.play("appear")
		if subwaylayer.visible:
			if ap.has_animation("subwayappear"):
				ap.play("subwayappear")
		if countrylayer.visible:
			if ap.has_animation("countryappear"):
				ap.play("countryappear")
		await get_tree().create_timer(0.1, true).timeout
		visible = true
		audio.play()
		panel.show()
		choices_box.PROCESS_MODE_ALWAYS
		await ap.animation_finished
		if ap.has_animation("hairsway"):
				ap.play("hairsway")
		text.show()
		choices_box.show()
		if controller.charm_active:
			print("reaches here")
			charm.disabled = false
			charm.show()
			print("charm showed")
		else:
			print("for some reason charm hides")
			charm.hide()
		if tutorial_wanted:
			tutlabel.show()
			tutanim.play("introtodialogue")
			print("introtodialogue")
			tutanim.animation_finished.connect(_on_intro_finished, CONNECT_ONE_SHOT)
			print("not wantec")
	else:
		print("No AnimationPlayer found in dlg_scene")
	
	if p.is_rps:
		rps_choices_box.show()
		if controller.charm_active:
			charm.disabled = false
			move_charm($Panel/Overlay/rpsbuttons/HBoxContainer3)
			charm.show()
		_play_rps_minigame(p)
		emit_signal("branch_chosen", 2)
		var picked:int = await _wait_for_choice()
		return picked
	else:
		choices_box.show()
		if controller.charm_active:
			charm.disabled = false
			move_charm($Panel/Overlay/Buttons/HBoxContainer3)
			charm.show()
		rand = rng.randi_range(1,2)
		if rand == 1:
			cor_idx = p.correct_idx
			text.text = p.dialogue_text if p.dialogue_text != "" else "..."
			_rebuild_buttons(p.choices if p.choices.size() > 0 else PackedStringArray(["OK"]))
		else:
			cor_idx = p.correct_idx_2
			text.text = p.dialogue_text_2 if p.dialogue_text_2 != "" else "..."
			_rebuild_buttons(p.choices2 if p.choices2.size() > 0 else PackedStringArray(["OK"]))
		_focus_normal()
		emit_signal("branch_chosen", cor_idx)
		var picked := await _wait_for_choice()
		is_rps_mode = false
		is_photoo = false
		visible = false
		return picked

func _rebuild_buttons(choices: PackedStringArray) -> void:
	var row1 = $Panel/Overlay/Buttons/HBoxContainer.get_children()
	var row2 = $Panel/Overlay/Buttons/HBoxContainer2.get_children()
	var rows = [row1, row2]
	
	for row in rows:
		for btn in row:
			if btn is TextureButton and btn != charm:
				btn.visible = false
				for c in btn.pressed.get_connections():
					btn.pressed.disconnect(c["callable"])
	
	var idx :=0
	for row in rows:
		for btn in row:
			if idx >= choices.size():
				break
			if btn is TextureButton and btn != charm:
				var lbl = btn.get_node("Label") as Label
				lbl.text = choices[idx]
				btn.visible = true
				btn.pressed.connect(Callable(self, "_on_choice_pressed").bind(idx))
				idx += 1
		
	await get_tree().create_timer(2.0, true).timeout
	for row in rows:
		for btn in row:
			if btn is TextureButton and btn.visible:
				btn.disabled = false
		
func _wait_for_choice() -> int:
	var picked:int = await self.choice_made
	choices_box.hide()
	rps_choices_box.hide()
	text.hide()
	if tutanim:
		tutanim.stop()
		tutanim.play("RESET")
	tutlabel.hide()
	var ap = dlg_scene.get_node_or_null("AnimationPlayer")
	var playeranim = dlg_scene.get_node_or_null("playeranim")
	var ap2 = dlg_scene.get_node_or_null("playerhandanim")
	var playertexture = dlg_scene.get_node_or_null("playerhand")
	var pos_response = dlg_scene.get_node_or_null("AudioStreamPlayer")
	var neg_response = dlg_scene.get_node_or_null("AudioStreamPlayer2")
	if is_photoo:
		print(ap2)
		playertexture.show()
		if rand == 1:
			print("rand = 1!! photo")
			if picked == 0:
				print("playing peacesign")
				ap2.play("peacesign")
			elif picked == 1:
				print("playing supermodel")
				ap2.play("supermodel")
		else:
			print("rand = 2!! photoayyyy")
			if picked == 0:
				print("playing fingerheart")
				ap2.play("fingerheart")
			elif picked == 3:
				print("playing taekwondo")
				ap2.play("taekwondo")
		print("TAKING PHOTO!")
		ap.play("takephoto")
		ap2.play("done")
		playertexture.hide()
		await ap.animation_finished
		await get_tree().create_timer(0.5).timeout
	if is_rps_mode:
		if enemy_move == 0:
			text.text = "Rock!"
			ap.play("rock")
			if charm_override:
				charm_override = false
				picked = 1
		elif enemy_move == 1:
			text.text = "Paper!"
			ap.play("paper")
			if charm_override:
				charm_override = false
				picked = 2
		elif enemy_move == 2:
			text.text = "Scissors!"
			ap.play("scissors")
			if charm_override:
				charm_override = false
				picked = 0
		playertexture.show()
		if picked == 0:
			playeranim.play("rock")
		elif picked == 1:
			playeranim.play("paper")
		elif picked == 2:
			playeranim.play("scissors")
		print(picked)
		print(enemy_move)
		await get_tree().create_timer(2.0).timeout
		if picked == enemy_move:
			is_rps_mode = false
			text.hide()
			playertexture.hide()
			if subwaylayer.visible:
				ap.play("angry")
			neg_response.play()
			await get_tree().create_timer(2.0).timeout
			visible = false
			return 1
		elif (picked == 0 and enemy_move == 2) \
		or (picked == 1 and enemy_move == 0) \
		or (picked == 2 and enemy_move == 1):
			is_rps_mode = false
			text.hide()
			playertexture.hide()
			ap.play("apologize")
			pos_response.play()
			await get_tree().create_timer(2.0).timeout
			visible = false
			return 2
		else:
			is_rps_mode = false
			text.hide()
			playertexture.hide()
			ap.play("angry")
			neg_response.play()
			await get_tree().create_timer(2.0).timeout
			return 0
	else:
		var wrong : bool = picked != cor_idx
		visible = true
		if is_delinq:
			if wrong:
				await start_delinq_event()
				if delinq_success:
					wrong = false
				else:
					wrong = true
			else:
				pass
		if wrong:
			ap.play("angry")
			neg_response.play()
		else:
			ap.play("apologize")
			pos_response.play()
		await get_tree().create_timer(2.0).timeout
		visible = false
		panel.hide()
		return picked
	
func _on_choice_pressed(idx:int) -> void:
	if controller.charm_active:
		thecharm = true
	emit_signal("choice_made", idx)

func _on_charm_pressed() -> void:
	print("reaches here")
	choices_box.hide()
	charm.hide()
	charm_override = true
	thecharm = false
	emit_signal("charm_used")
	emit_signal("choice_made", cor_idx)

func close_dialogue():
	if tutanim:
		tutanim.stop()
		tutanim.play("RESET")
	tutlabel.hide()
	if is_instance_valid(dlg_scene):
		var ap:= dlg_scene.get_node_or_null(("AnimationPlayer"))
		if ap: ap.stop()
		dlg_scene.queue_free()
		dlg_scene = null
	text.hide()
	tutorial_wanted = false
	audio.stop()
	rps_choices_box.hide()
	charm.hide()
	text.hide()
	move_charm($Panel/Overlay)
	visible = false

func _on_intro_finished(anim_name: String) -> void:
	if anim_name == "introtodialogue":
		if controller.charm_active:
			if tutorial_wanted:
				print("here's a charm")
				tutanim.play("heresacharm")
		else:
			if tutorial_wanted:
				tutanim.play("heresnotacharm")
				print("here's not a charm")
		
		again_tutorial_wanted = false

func _play_rps_minigame(p: EnemyProfile) -> void:
	is_rps_mode = true
	choices_box.hide()
	rps_choices_box.show()
	
	var ap = dlg_scene.get_node_or_null("AnimationPlayer")
	text.text = p.dialogue_text if p.dialogue_text != "" else "..."
	
	_rebuild_rps_buttons(p.choices if p.choices.size() > 0 else PackedStringArray(["Rock","Paper","Scissors"]))
	_focus_rps()
	print("rps box vis:", rps_choices_box.visible, " mod:", rps_choices_box.modulate)

	enemy_move = rng.randi_range(0, 2)
	var enemy_string_move = ""
	if enemy_move == 0:
		enemy_string_move = "rock"
	elif enemy_move == 1:
		enemy_string_move = "paper"
	elif enemy_move == 2:
		enemy_string_move = "scissors"
	print("enemy_move", enemy_move, enemy_string_move)


func _on_rps_choice_pressed(idx:int) -> void:
	emit_signal("choice_made", idx)

func _rebuild_rps_buttons(choices: PackedStringArray) -> void:
	var idx := 0

	for row in rps_choices_box.get_children():
		if row is HBoxContainer:
			for btn in row.get_children():
				if btn is TextureButton and btn != charm:
					if idx < choices.size():
						btn.visible = true
						btn.disabled = false

						for c in btn.pressed.get_connections():
							btn.pressed.disconnect(c["callable"])
						btn.pressed.connect(Callable(self, "_on_rps_choice_pressed").bind(idx))

						idx += 1
					else:
						btn.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		var f := get_viewport().gui_get_focus_owner()
		if f is BaseButton and f.is_visible_in_tree():
			var b := f as BaseButton
			if b and b.is_visible_in_tree() and not b.disabled:
				b.emit_signal("pressed")
				var vp := get_viewport()
				if vp:
					vp.set_input_as_handled()

func _focus_normal() -> void:
	var matrix : Array = []
	for hbox in [$Panel/Overlay/Buttons/HBoxContainer.get_children(), $Panel/Overlay/Buttons/HBoxContainer2.get_children(), $Panel/Overlay/Buttons/HBoxContainer3.get_children()]:
		var cols: Array = []
		for n in hbox:
			if n is TextureButton and n.visible:
				(n as Control).focus_mode = Control.FOCUS_ALL
				cols.append(n)
		matrix.append(cols)
		
	for r in matrix.size():
		var cols : Array = matrix[r]
		var n := cols.size()
		if n == 0: continue
		for c in n:
			var b := cols[c] as Control
			b.focus_neighbor_left = cols[(c-1 + n) % n].get_path()
			b.focus_neighbor_right = cols[(c+1) % n].get_path()
	
	for r in matrix.size():
		var cols : Array = matrix[r]
		for c in cols.size():
			var b := cols[c] as Control
			var r_up := (r-1 + matrix.size()) % matrix.size()
			var r_dn := (r+1) % matrix.size()
			var up_row: Array = matrix[r_up]
			var down_row: Array = matrix[r_dn]
			if c < up_row.size():
				b.focus_neighbor_top = (up_row[c] as Control).get_path()
			if c < down_row.size():
				b.focus_neighbor_bottom = (down_row[c] as Control).get_path()
		
		if matrix.size() > 0 and matrix[0].size() > 0:
			(matrix[0][0] as Control).grab_focus()

func _focus_rps() -> void:
	var matrix : Array = []
	for hbox in [$Panel/Overlay/rpsbuttons/HBoxContainer.get_children(), $Panel/Overlay/rpsbuttons/HBoxContainer3.get_children()]:
		var cols: Array = []
		for n in hbox:
			if n is TextureButton and n.visible:
				(n as Control).focus_mode = Control.FOCUS_ALL
				cols.append(n)
		matrix.append(cols)
		
	for r in matrix.size():
		var cols : Array = matrix[r]
		var n := cols.size()
		if n == 0: continue
		for c in n:
			var b := cols[c] as Control
			b.focus_neighbor_left = cols[(c-1 + n) % n].get_path()
			b.focus_neighbor_right = cols[(c+1) % n].get_path()
	
	for r in matrix.size():
		var cols : Array = matrix[r]
		for c in cols.size():
			var b := cols[c] as Control
			var r_up := (r-1 + matrix.size()) % matrix.size()
			var r_dn := (r+1) % matrix.size()
			var up_row: Array = matrix[r_up]
			var down_row: Array = matrix[r_dn]
			if c < up_row.size():
				b.focus_neighbor_top = (up_row[c] as Control).get_path()
			if c < down_row.size():
				b.focus_neighbor_bottom = (down_row[c] as Control).get_path()
		
		if matrix.size() > 0 and matrix[0].size() > 0:
			(matrix[0][0] as Control).grab_focus()

func move_charm(to_container: Control):
	charm.get_parent().remove_child(charm)
	to_container.add_child(charm)

func start_delinq_event() -> void:
	var ap = dlg_scene.get_node_or_null("AnimationPlayer")
	ap.play("punch_incoming")
	await get_tree().create_timer(0.1).timeout
	var timer = get_tree().create_timer(1.75)
	while timer.time_left > 0:
		await get_tree().process_frame
		if Input.is_action_just_pressed("ui_accept"):
			delinq_success = true
			break
	if delinq_success:
		ap.play("punch_dodge")
		await ap.animation_finished
	else:
		ap.play("punch")
		await ap.animation_finished
