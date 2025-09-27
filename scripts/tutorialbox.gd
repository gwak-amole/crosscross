extends Control

signal tutorialfinished
@export var typing_speed: float = 0.03
@export var controllerpath : NodePath
@export var dialogueboxpath : NodePath
@export var tutorial_steps := [
	{"anim": "step_0",},
	{"anim": "step_1",},
	{"anim": "step_2",},
	{"anim": "step_3",},
	{"anim": "step_4",},
	{"anim": "step_5",},
]

@onready var anim: AnimationPlayer = $begintut
@onready var audio := $AudioStreamPlayer
@onready var controller := get_node(controllerpath)
@onready var dialoguebox := get_node(dialogueboxpath)

var step_idx: int = 0
var line_idx: int = 0
var is_typing: bool = false
var skip_typing: bool = false
var again_tutorial_wanted := false
var tutorial_wanted := false

func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED
	if again_tutorial_wanted == false:
		var yes: bool = await controller.tutorial
		tutorial_wanted = yes
		if tutorial_wanted:
			process_mode = Node.PROCESS_MODE_ALWAYS
			audio.play()
			get_tree().paused = true
			show()
			_play_step(step_idx)
		else:
			get_tree().paused = false
	else:
		tutorial_wanted = false
	if not dialoguebox.step_finished.is_connected(_on_step_finished):
		dialoguebox.step_finished.connect(_on_step_finished)
				
func _play_step(idx: int) -> void:
	line_idx = 0
	if anim and tutorial_steps[idx]["anim"] != "":
		anim.play(tutorial_steps[idx]["anim"])
	
	var step_lines = _get_lines_for_step(tutorial_steps[idx]["anim"])
	if step_lines.size() > 0:
		dialoguebox.start_dialogue(step_lines, step_idx == 0)

func _on_step_finished() -> void:
	step_idx += 1
	if step_idx < tutorial_steps.size():
		_play_step(step_idx)
	else:
		_end_tutorial()

func _end_tutorial() -> void:
	anim.play("step_6")
	dialoguebox.anim.play("end")
	dialoguebox.anim2.play("notok")
	await anim.animation_finished
	hide()
	get_tree().paused = false
	again_tutorial_wanted = false
	anim.stop()
	audio.stop()
	emit_signal("tutorialfinished")

func _get_lines_for_step(step: String) -> Array:
	match step:
		"step_0":
			return ["Welcome to Crosscross!", "You are an officeman, just trying to cross the street to get to work!"]
		"step_1":
			return ["People might run into you!", "Try to work it out with them through conversation, even if you don't know their language!"]
		"step_2":
			return ["You'll find coins.", "If you get 5, you'll have a FEVER!", "During a FEVER, everything goes faster but points MULTIPLY!"]
		"step_3":
			return ["Shields will protect you from your next encounter so that you don't have to talk."]
		"step_4":
			return ["Charms will charm the person you bumped into so that they will forgive you!"]
		"step_5":
			return ["Use ARROWS or WASD to move around.", "Choose dialogue options with ARROWS/WASD and SPACE.", "Pause the game using ESC.", "Good luck!"]
		_:
			return []
