extends CharacterBody2D

signal puddle_contacted
@export var profile_array : Array[EnvMishapProfile]
var _profile: EnvMishapProfile

@export var profile: EnvMishapProfile:
	set(value):
		_profile =value
		if _profile and sprite:
			sprite.texture = _profile.texture
			print(profile, profile.texture)
	get:
		return _profile

@onready var sprite: Sprite2D = $Sprite2D

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name != "player_hitbox": return
	emit_signal("puddle_contacted", self)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
