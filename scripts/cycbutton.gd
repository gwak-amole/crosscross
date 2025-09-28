extends Button

@export var characterselectpath : NodePath

@onready var anim := $AnimatedSprite2D
@onready var charselect := get_node(characterselectpath)

func _ready():
	pass

func _on_pressed():
	anim.play("pressed")
	print("pressed")
	if self.name == "Button":
		charselect._on_character_button_pressed("0")
	elif self.name == "Button2":
		charselect._on_character_button_pressed("1")
	elif self.name == "Button3":
		charselect._on_character_button_pressed("2")
	
func _on_focused():
	anim.play("focused")

func _on_unfocused():
	anim.play("default")
