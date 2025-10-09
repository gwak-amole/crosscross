extends Resource
class_name BoatsProfile

@export var display_name: String
@export var speed: float
@export_enum("jp", "en", "kr", "cn", "fr", "rand") var language: String = "jp"
@export var anim_idle: String = "idle"
@export var anim_contact: String = "contact"
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
@export var is_delinq: bool = false
@export var is_photo: bool = false
@export var is_boat: bool = true
