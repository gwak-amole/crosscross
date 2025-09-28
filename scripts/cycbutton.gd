extends TextureButton

@onready var anim := $AnimatedSprite2D

func _ready():
	anim.play("idle")

func _on_pressed():
	anim.play("pressed")
	
func _on_focused():
	anim.play("focused")

func _on_unfocused():
	anim.play("idle")
