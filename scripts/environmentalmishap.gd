extends CharacterBody2D

signal puddle_contacted
@export var profile_array : Array[EnvMishapProfile]
@export var profile: EventProfile


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name != "player_hitbox": return
	emit_signal("puddle_contacted", self)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
