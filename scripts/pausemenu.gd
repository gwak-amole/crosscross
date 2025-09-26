extends CanvasLayer

@onready var resume_btn: TextureButton = $Control/Panel/VBoxContainer/Resume
@onready var restart_btn: TextureButton = $Control/Panel/VBoxContainer/Restart
@onready var quit_btn: TextureButton = $Control/Panel/VBoxContainer/Quit

func _ready() -> void:
	hide()
	resume_btn.pressed.connect(_on_resume_pressed)
	restart_btn.pressed.connect(_on_restart_pressed)
	quit_btn.pressed.connect(_on_quit_pressed)
	
func open() -> void:
	show()
	get_tree().paused = true
	resume_btn.grab_focus()
	
func close() -> void:
	hide()
	get_tree().paused = false

func _on_resume_pressed() -> void:
	close()

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
