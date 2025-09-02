extends CanvasLayer
signal choice_made(idx: int)
@export var audio_path : NodePath

@onready var panel := $Panel
@onready var art : Node = $Panel/Art
@onready var text := $Panel/Overlay/Text
@onready var choices_box := $Panel/Overlay/Buttons
@onready var audio := get_node(audio_path)
var dlg_scene: Node = null
var cor_idx : int

func _ready() -> void:
	visible = false
	panel.hide()
	choices_box.hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func show_dialogue_from_profile(p: EnemyProfile) -> int:
	visible = false
	panel.hide()
	if is_instance_valid(dlg_scene):
		dlg_scene.queue_free()
	
	dlg_scene = p.dialogue_scene.instantiate()
	dlg_scene.process_mode = Node.PROCESS_MODE_ALWAYS
	panel.add_child(dlg_scene)
	
	cor_idx = p.correct_idx
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
		choices_box.show()
		if ap.has_animation("hairsway"):
			ap.play("hairsway")
	else:
		print("No AnimationPlayer found in dlg_scene")
	
	text.text = p.dialogue_text if p.dialogue_text != "" else "..."
	_rebuild_buttons(p.choices if p.choices.size() > 0 else PackedStringArray(["OK"]))
	
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
	emit_signal("choice_made", idx)

func close_dialogue():
	if is_instance_valid(dlg_scene):
		var ap:= dlg_scene.get_node_or_null(("AnimationPlayer"))
		if ap: ap.stop()
		dlg_scene.queue_free()
		dlg_scene = null
	audio.stop()
	visible = false
