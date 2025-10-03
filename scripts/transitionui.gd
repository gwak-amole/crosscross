extends Node2D

signal fade_done

@onready var rect: ColorRect = $CanvasLayer/ColorRect
@onready var anim: AnimationPlayer = $CanvasLayer/AnimationPlayer

func _ready():
	rect.hide()

func fade_in(duration: float = 0.5) -> void:
	if not anim.has_animation("fade_in"):
		push_warning("Missing fade_in anim")
		return
	rect.show()
	anim.play("fade_in")
	await anim.animation_finished
	emit_signal("fade_done")

func fade_out(duration: float = 0.5) -> void:
	print("fading out")
	if not anim.has_animation("fade_out"):
		push_warning("missin fade_out anim")
		return
	anim.play("fade_out")
	await anim.animation_finished
	emit_signal("fade_done")
	rect.hide()
