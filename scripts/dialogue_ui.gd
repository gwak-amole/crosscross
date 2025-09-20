extends CanvasLayer
signal choice_made(idx: int)
signal branch_chosen(idx: int)
@export var audio_path : NodePath
@export var spawnerpath : NodePath
@export var animpath : NodePath
@export var charmpath : NodePath
@export var controllerpath : NodePath
@export var tutanimpath : NodePath
@export var tutlabelpath : NodePath

@onready var panel := $Panel
@onready var art : Node = $Panel/Art
@onready var text := $Panel/Overlay/Text
@onready var choices_box := $Panel/Overlay/Buttons
@onready var rps_choices_box := $Panel/Overlay/rpsbuttons
@onready var audio := get_node(audio_path)
@onready var spawner := get_node(spawnerpath)
@onready var anim := get_node(animpath)
@onready var charm := get_node(charmpath)
@onready var controller := get_node(controllerpath)
@onready var tutanim := get_node(tutanimpath)
@onready var tutlabel := get_node(tutlabelpath)

var dlg_scene: Node = null
var cor_idx : int
var rng = RandomNumberGenerator.new()
var rand: int
var thecharm : bool = false
var tutorial_wanted : bool = false
var again_tutorial_wanted : bool = false
var is_rps_mode : bool = false
var enemy_move : int = -1

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
	
	var ap = dlg_scene.get_node_or_null("AnimationPlayer")
	if ap:
		await get_tree().create_timer(1.5).timeout
		print("playing animations")
		if ap.has_animation("appear"):
			ap.play("appear")
			await get_tree().create_timer(0.1).timeout
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
			charm.show()
			charm.queue_redraw()
		if tutorial_wanted:
			tutlabel.show()
			tutanim.play("introtodialogue")
			print("introtodialogue")
			tutanim.animation_finished.connect(_on_intro_finished, CONNECT_ONE_SHOT)
			print("not wantec")
	else:
		print("No AnimationPlayer found in dlg_scene")
	
	if p.is_rps:
		_play_rps_minigame(p)
		emit_signal("branch_chosen", 2)
		var picked:int = await _wait_for_choice()
		visible = false
		return picked
	else:
		rand = rng.randi_range(1,2)
		if rand == 1:
			cor_idx = p.correct_idx
			text.text = p.dialogue_text if p.dialogue_text != "" else "..."
			_rebuild_buttons(p.choices if p.choices.size() > 0 else PackedStringArray(["OK"]))
		else:
			cor_idx = p.correct_idx_2
			text.text = p.dialogue_text_2 if p.dialogue_text_2 != "" else "..."
			_rebuild_buttons(p.choices2 if p.choices2.size() > 0 else PackedStringArray(["OK"]))

		emit_signal("branch_chosen", cor_idx)
		
		var picked := await _wait_for_choice()
		is_rps_mode = false
		visible = false
		return picked

func _rebuild_buttons(choices: PackedStringArray) -> void:
	var row1 = $Panel/Overlay/Buttons/HBoxContainer.get_children()
	var row2 = $Panel/Overlay/Buttons/HBoxContainer2.get_children()
	var rows = [row1, row2]
	
	for row in rows:
		for btn in row:
			if btn is TextureButton:
				btn.visible = false
				for c in btn.pressed.get_connections():
					btn.pressed.disconnect(c["callable"])
	
	var idx :=0
	for row in rows:
		for btn in row:
			if idx >= choices.size():
				break
			if btn is TextureButton:
				var lbl = btn.get_node("Label") as Label
				lbl.text = choices[idx]
				btn.visible = true
				btn.pressed.connect(Callable(self, "_on_choice_pressed").bind(idx))
				idx += 1
	
	await get_tree().create_timer(2.0).timeout
	for row in rows:
		for btn in row:
			if btn is TextureButton and btn.visible:
				btn.disabled = false
		
func _wait_for_choice() -> int:
	var picked:int = await self.choice_made
	choices_box.hide()
	rps_choices_box.hide()
	if tutanim:
		tutanim.stop()
		tutanim.play("RESET")
	tutlabel.hide()
	var ap = dlg_scene.get_node_or_null("AnimationPlayer")
	var pos_response = dlg_scene.get_node_or_null("AudioStreamPlayer")
	var neg_response = dlg_scene.get_node_or_null("AudioStreamPlayer2")
	
	if is_rps_mode:
		if picked == enemy_move:
			ap.play("angry")
			neg_response.play()
			await get_tree().create_timer(2.0).timeout
			visible = false
			return 1
		elif (picked == 0 and enemy_move == 2) \
		or (picked == 1 and enemy_move == 0) \
		or (picked == 2 and enemy_move == 1):
			ap.play("apologize")
			pos_response.play()
			await get_tree().create_timer(2.0).timeout
			visible = false
			return 2
		else:
			ap.play("angry")
			neg_response.play()
			await get_tree().create_timer(2.0).timeout
			visible = false
			return 0
	else:
		var wrong : bool = picked != cor_idx
		visible = true
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
	choices_box.hide()
	charm.hide()
	thecharm = false
	print("it's reaching here")
	if rps_choices_box.visible == true:
		emit_signal("choice_made", 2)
		print("charm choice")
	else:
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
	tutlabel.hide()
	tutorial_wanted = false
	audio.stop()
	rps_choices_box.hide()
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
				if btn is TextureButton:
					if idx < choices.size():
						var lbl: Label = btn.get_node("Label")
						lbl.text = choices[idx]

						btn.visible = true
						btn.disabled = false

						for c in btn.pressed.get_connections():
							btn.pressed.disconnect(c["callable"])
						btn.pressed.connect(Callable(self, "_on_rps_choice_pressed").bind(idx))

						idx += 1
					else:
						btn.visible = false
