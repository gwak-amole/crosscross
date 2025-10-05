extends Control
@onready var anim := $AnimationPlayer

func _ready() -> void:
	anim.play("mainmenu")
	_focus_menu()
	await get_tree().process_frame
	await get_tree().process_frame
	if $VBoxContainer/"Start Button".visible:
		$VBoxContainer/"Start Button".grab_focus()
	Globals.chosen_gender = 0
	Globals.chosen_character = "-1"
		
func _on_start_button_pressed() -> void:
	anim.play("exit")
	await anim.animation_finished
	print("switching")
	get_tree().change_scene_to_file("res://scenes/choosegender.tscn")

func _on_instructions_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options.tscn")


func _on_button_pressed() -> void:
	var scene = load("res://scenes/leaderboard.tscn") as PackedScene
	var go := scene.instantiate()
	go.from_gameover = false
	var tree = get_tree()
	var old = tree.current_scene
	tree.root.add_child(go)
	tree.current_scene = go
	if old:
		old.queue_free()

func _focus_menu() -> void:
	var cols: Array = []
	for n in $VBoxContainer.get_children():
		if n is Button and n.visible:
			(n as Control).focus_mode = Control.FOCUS_ALL
			cols.append(n)
	
	for i in cols.size():
		var b := cols[i] as Control
		b.focus_neighbor_top = cols[(i-1 + cols.size()) % cols.size()].get_path()
		b.focus_neighbor_bottom = cols[(i+1) % cols.size()].get_path()
		b.focus_neighbor_left = b.get_path()
		b.focus_neighbor_right = b.get_path()
		
	if cols.size() > 0:
		await get_tree().process_frame
		(cols[0] as Control).grab_focus()
