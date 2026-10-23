extends Control
@export var lineedit_path : NodePath
@export var confirm_path_1 : NodePath

@onready var label := $ColorRect/VBoxContainer/MarginContainer/Label
@onready var lineedit := get_node_or_null(lineedit_path)
@onready var confirm := get_node_or_null(confirm_path_1)
var is_confirming := false

func _ready():
	hide()
	print(label)
	print(lineedit)
	print(is_confirming)
	print(lineedit_path)
	if lineedit:
		lineedit.focus_entered.connect(_on_line_edit_focus_entered)
		self.focus_exited.connect(_on_keyboard_focus_exited)


func key_press(letter: String):
	print("key_press")
	lineedit.text += letter
	lineedit.caret_column = lineedit.text.length()
	label.text += letter
	print(letter)


func key_clear() -> void:
	label.text = ""
	lineedit.text = ""


func key_confirm() -> void:
	is_confirming = true
	hide()
	confirm.grab_focus()
	await get_tree().create_timer(0.01).timeout
	is_confirming = false


func key_backspace() -> void:
	var current_text = label.text
	if not current_text.is_empty():
		label.text = current_text.left(current_text.length() - 1)
	var current_text_1 = lineedit.text 
	if not current_text_1.is_empty():
		lineedit.text = current_text_1.left(current_text.length() - 1)
		lineedit.caret_column = lineedit.text.length()

func _on_line_edit_focus_entered():
	if is_confirming:
		return
	show()
	$ColorRect/VBoxContainer/GridContainer/A.grab_focus()
	
func _on_keyboard_focus_exited():
	if is_confirming:
		return
	
	hide()
