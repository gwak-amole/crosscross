extends CanvasLayer
signal choice_made(idx: int)
signal branch_chosen(idx: int)
@export var audio_path : NodePath
@export var spawnerpath : NodePath
@export var animpath : NodePath
@export var charmpath : NodePath
@export var controllerpath : NodePath

@onready var panel := $Panel
@onready var art : Node = $Panel/Art
@onready var text := $Panel/Overlay/Text
@onready var choices_box := $Panel/Overlay/Buttons
@onready var audio := get_node(audio_path)
@onready var spawner := get_node(spawnerpath)
@onready var anim := get_node(animpath)
@onready var charm := get_node(charmpath)
@onready var controller := get_node(controllerpath)

var dlg_scene: Node = null
var cor_idx : int
var rng = RandomNumberGenerator.new()
var rand: int
var thecharm : bool = false

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	if charm and charm is TextureButton:
		if not charm.pressed.is_connected(_on_charm_pressed):
			charm.pressed.connect(_on_charm_pressed)
	else:
		push_error("Charm button not found haiya")

func show_dialogue_from_profile(p: EnemyProfile) -> int:
	rand = rng.randi_range(1,2)
	visible = false
	panel.hide()
	choices_box.hide()
	text.hide()
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
		await ap.animation_finished
		text.show()
		choices_box.show()
		if controller.charm_active:
			charm.show()
			charm.queue_redraw()
		if ap.has_animation("hairsway"):
			ap.play("hairsway")
	else:
		print("No AnimationPlayer found in dlg_scene")
	
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
		
func _wait_for_choice() -> int:
	var picked:int = await self.choice_made
	choices_box.hide()
	charm.hide()
	var ap = dlg_scene.get_node_or_null("AnimationPlayer")
	var pos_response = dlg_scene.get_node_or_null("AudioStreamPlayer")
	var neg_response = dlg_scene.get_node_or_null("AudioStreamPlayer2")
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
	thecharm = false
	print("it's reaching here")
	emit_signal("choice_made", cor_idx)

func close_dialogue():
	if is_instance_valid(dlg_scene):
		var ap:= dlg_scene.get_node_or_null(("AnimationPlayer"))
		if ap: ap.stop()
		dlg_scene.queue_free()
		dlg_scene = null
	audio.stop()
	visible = false
