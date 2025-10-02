extends CanvasLayer
signal choice_made(idx: int)
@export var audio_path : NodePath
@export var controllerpath : NodePath
@export var dialogue_scene : PackedScene
@export var dialogue_holder : NodePath

@onready var panel := $Panel
@onready var text := $Panel/Overlay/Text
@onready var choices_box := $Panel/Overlay/HBoxContainer2
@onready var audio := get_node(audio_path)
@onready var controller := get_node(controllerpath)
@onready var dialogueholder := get_node(dialogue_holder)

var dlg_scene: Node = null

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	for btn in choices_box.get_children():
		if btn is TextureButton:
			btn.focus_mode = Control.FOCUS_ALL
			btn.mouse_filter = Control.MOUSE_FILTER_IGNORE

func show_dialogue_from_profile(p: Node) -> int:
	visible = false
	panel.hide()
	text.hide()
	choices_box.hide()
	if is_instance_valid(dlg_scene):
		dlg_scene.queue_free()
	dlg_scene = dialogue_scene.instantiate()
	dlg_scene.process_mode = Node.PROCESS_MODE_ALWAYS
	dialogueholder.add_child(dlg_scene)
	var ap = dlg_scene.get_node_or_null("AnimationPlayer")
	if ap:
		await get_tree().create_timer(1.5, true).timeout
		print("playing animations")
		if ap.has_animation("appear"):
			ap.play("appear")
			await get_tree().create_timer(0.1, true).timeout
			visible = true
			audio.play()
			panel.show()
			choices_box.process_mode = Node.PROCESS_MODE_ALWAYS
		await ap.animation_finished
		if ap.has_animation("hairsway"):
			ap.play("hairsway")
		text.show()
		choices_box.show()
		print("text and choices box supposed to show")
	else:
		print("No AnimationPlayer found in dlg_scene")
	choices_box.show()
	text.text = "Would you like to go to Kyoto?"
	_rebuild_buttons(["Yes", "No"])
	_focus_normal()
	var picked := await _wait_for_choice()
	visible = false
	return picked

func _rebuild_buttons(choices: PackedStringArray) -> void:
	var row = $Panel/Overlay/HBoxContainer2.get_children()
	
	for btn in row:
		if btn is TextureButton:
			btn.visible = false
			for c in btn.pressed.get_connections():
				btn.pressed.disconnect(c["callable"])
	
	var idx :=0
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
	text.hide()
	var ap = dlg_scene.get_node_or_null("AnimationPlayer")
	var pos_response = dlg_scene.get_node_or_null("AudioStreamPlayer")
	var neg_response = dlg_scene.get_node_or_null("AudioStreamPlayer2")

	var yes : bool = picked == 0
	visible = true
	if yes:
		ap.play("ticket")
		# pos_response.play()
	else:
		ap.play("bye")
		# neg_response.play()
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
	text.hide()
	audio.stop()
	text.hide()
	visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		var f := get_viewport().gui_get_focus_owner()
		if f is BaseButton and f.is_visible_in_tree():
			if not f.disabled:
				f.emit_signal("pressed")
				get_viewport().set_input_as_handled()

func _focus_normal() -> void:
	var cols: Array = []
	for btn in choices_box.get_children():
		if btn is TextureButton and btn.visible:
			btn.focus_mode = Control.FOCUS_ALL
			cols.append(btn)
	var n = cols.size()
	if n == 0:
		return
	for c in range(n):
		var b := cols[c] as Control
		b.focus_neighbor_left = cols[(c-1 + n) % n].get_path()
		b.focus_neighbor_right = cols[(c+1) % n].get_path()
		
		(cols[0] as Control).grab_focus()
