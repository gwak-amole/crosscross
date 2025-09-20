extends Resource
class_name EnemyProfile

@export var display_name: String = "Office Worker"
@export var speed: float = 200
@export_enum("jp", "en", "kr", "cn", "fr", "rand") var language: String = "jp"
@export var anim_idle: String
@export var anim_contact: String
@export var sprite_frames: SpriteFrames

@export var dialogue_scene: PackedScene
@export var dialogue_text: String
@export var dialogue_text_2: String
@export var choices: PackedStringArray
@export var choices2: PackedStringArray
@export var correct_idx: int
@export var correct_idx_2: int
@export var gender : String
@export var is_rps: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
