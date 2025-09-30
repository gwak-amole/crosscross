extends Button

@export var characterselectpath : NodePath

@onready var anim := $AnimatedSprite2D
@onready var charselect := get_node(characterselectpath)

var is_selected := false

func _ready():
	update_visual()

func _on_pressed():
	anim.play("pressed")
	print("pressed")
	if self.name == "Button":
		charselect._on_character_button_pressed("0")
	elif self.name == "Button2":
		charselect._on_character_button_pressed("1")
	elif self.name == "Button3":
		charselect._on_character_button_pressed("2")
	for sibling in get_parent().get_children():
		if sibling is Button and sibling != self:
			sibling.is_selected = false
			sibling.update_visual()
	is_selected = true
	update_visual()
	
func _on_focused():
	anim.play("focused")

func _on_unfocused():
	anim.play("default")

func update_visual():
	if is_selected:
		add_theme_stylebox_override("normal", get_theme_stylebox("focus", "Button"))
	else:
		remove_theme_stylebox_override("normal")
