extends CharacterBody2D


const SPEED = 200.0
var current_dir = "none"

func _ready():
	$AnimatedSprite2D.play("idle")

func _physics_process(delta: float) -> void:
	player_movement(delta)
	
func player_movement(delta):
	
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
		velocity.y = 0
		current_dir = "right"
		play_anim(1)
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
		velocity.y = 0
		current_dir = "left"
		play_anim(1)
	elif Input.is_action_pressed("ui_down"):
		velocity.x = 0
		velocity.y = SPEED
		current_dir = "down"
		play_anim(1)
	elif Input.is_action_pressed("ui_up"):
		velocity.x = 0
		velocity.y = -SPEED
		current_dir = "up"
		play_anim(1)
	else:
		velocity.x = 0
		velocity.y = 0
		play_anim(0)
	
	move_and_slide()

func play_anim(animation):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if animation == 1:
			anim.play("walkingside")
		elif animation == 0:
			anim.play("idleside")
	elif dir == "left":
		anim.flip_h = true
		if animation == 1:
			anim.play("walkingside")
		elif animation == 0:
			anim.play("idleside")
	elif dir == "down":
		anim.flip_v = true
		if animation == 1:
			anim.play("walkingvert")
		elif animation == 0:
			anim.play("idle")
	elif dir == "up":
		anim.flip_v = false
		if animation == 1:
			anim.play("walkingvert")
		elif animation == 0:
			anim.play("idle")
