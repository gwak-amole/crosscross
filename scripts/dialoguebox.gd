extends Control

@export var typing_speed: float = 0.03
@export var controllerpath : NodePath
@export var thelines:= []

@onready var label: Label = $Label
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var anim2 := $okanim
@onready var dlg_box:= $TextureRect
@onready var controller := get_node(controllerpath)

var step_idx: int = 0
var line_idx: int = 0
var is_typing: bool = false
var skip_typing: bool = false
var ready_for_input : bool = false

signal step_finished

func _ready() -> void:
	visible = false

func start_dialogue(lines: Array, reset_box: bool = false) -> void:
	thelines = lines
	step_idx = 0
	line_idx = 0
	anim.play("show")
	
	if reset_box:
		visible = true
		anim.play("show")
		dlg_box.show()
		await anim.animation_finished
		anim.play("default")
	
	anim2.play("notok")
	ready_for_input = true
	_show_line()

func _show_line() -> void:
	if line_idx >= thelines.size():
		anim.play("end")
		anim2.play("notok")
		ready_for_input = false
		emit_signal("step_finished")
		return

	label.text = ""
	is_typing = true
	skip_typing = false
	_start_typing(thelines[line_idx])
	
func _start_typing(text: String) -> void:
	anim2.play("notok")
	await _typewriter(text)
	anim2.play("ok")
	is_typing = false
	
func _typewriter(text: String) -> void:
	for i in text.length():
		if skip_typing:
			label.text = text
			break
		label.text += text[i]
		await get_tree().create_timer(typing_speed).timeout
		
func _advance_line() -> void:
	line_idx += 1
	_show_line()
	
func _unhandled_input(event: InputEvent) -> void:
	if not ready_for_input or not visible:
		return
		
	if event.is_action_pressed("ui_accept"):
		if is_typing:
			skip_typing = true
		else:
			_advance_line()
		get_viewport().set_input_as_handled()

func _play_step() -> void:
	line_idx = 0
	_show_line()
