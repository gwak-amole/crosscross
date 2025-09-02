extends AudioStreamPlayer

func _process(delta) -> void:
	if get_tree().current_scene:
		if get_tree().current_scene.scene_file_path == "res://scenes/gamebase.tscn" or get_tree().current_scene.scene_file_path == "res://scenes/gameover.tscn":
			stop()
	else:
		if self.playing == true:
			pass
		else:
			play()


func _on_finished() -> void:
	play()
