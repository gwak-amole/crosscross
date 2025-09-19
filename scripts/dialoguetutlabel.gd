extends Label

@export var typing_speed: float = 0.05

func type_out(message: String) -> void:
	text = ""
	for i in range(message.length()):
		text += message[i]
		await get_tree().create_timer(typing_speed).timeout
