extends CharacterBody2D
signal contacted(enemy: CharacterBody2D)
signal heytut

@export var dir: Vector2 = Vector2.DOWN
@export var profile: EnemyProfile
@export var tutorialpath : NodePath

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $enemy_hitbox
@onready var onscreen: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var tutorial := get_node(tutorialpath)

var _anim_idle: StringName = &"idle"
var _anim_contact: StringName = &"contact"
var speed: float = 80.0
var slowed : bool = false

enum State { MOVE, CONTACTED }
var state: State = State.MOVE

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	if onscreen and not onscreen.screen_exited.is_connected(_on_screen_exited):
		onscreen.screen_exited.connect(_on_screen_exited)
	if profile:
		if profile.sprite_frames:
			anim.sprite_frames = profile.sprite_frames
		if profile.anim_idle != "":
			_anim_idle = profile.anim_idle
		if profile.anim_contact != "":
			_anim_contact = profile.anim_contact

	if anim.sprite_frames and anim.sprite_frames.has_animation(_anim_idle):
		anim.play(_anim_idle)

	var cb := Callable(self, "_on_enemy_hitbox_area_entered")
	if not hitbox.area_entered.is_connected(cb):
		hitbox.area_entered.connect(cb)

func _physics_process(delta: float) -> void:
	if state != State.MOVE: return
	if get_tree().paused == true:
		velocity = Vector2.ZERO
	else:
		var actual_speed: float
		if profile:
			actual_speed = profile.speed
		else:
			actual_speed = speed
		
		if slowed:
			actual_speed *= 0.05
		
		velocity = dir * actual_speed
	move_and_slide()

func _on_enemy_hitbox_area_entered(area: Area2D) -> void:
	if state != State.MOVE: return
	if area.name != "player_hitbox": return
	
	state = State.CONTACTED
	hitbox.monitoring = false
	if anim.sprite_frames and anim.sprite_frames.has_animation(_anim_contact):
		anim.play(_anim_contact)
	print("[ENEMY] contact.")
	emit_signal("contacted", self)

func _on_screen_exited() -> void:
	emit_signal("heytut")
	queue_free()


func _on_enemy_slowdown_area_entered(area: Area2D) -> void:
	if state != State.MOVE: return
	if area.name == "player_hitbox": return
	if area.name == "enemy_hitbox" and area.get_parent() != self:
		print("should be slowing down")
		set_slowed(true)


func _on_enemy_slowdown_area_exited(area: Area2D) -> void:
	if state != State.MOVE: return
	if area.name == "player_hitbox": return
	if area.name == "enemy_hitbox" and area.get_parent() != self:
		print("should be exiting")
		set_slowed(false)


func set_slowed(value: bool) -> void:
	slowed = value
