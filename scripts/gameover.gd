extends Control

@onready var anim := $AnimationPlayer
@onready var audio := $AudioStreamPlayer
@onready var points := $points/Panel/Label
@onready var btn := $TextureButton
@onready var gmovmsg := $gameovermessage
var rng = RandomNumberGenerator.new()
var rand : int = -1
var final_points : int = 0
var from_leaderboard := false

func _ready() -> void:
	print("remember rand", Globals.remember_rand, rand)
	if Globals.remember_rand >= 0:
		rand = Globals.remember_rand
	else:
		rand = rng.randi_range(0,6)
	anim.play("gameover")
	audio.play()
	print(final_points)
	points.text = ("Points: " + str(final_points))
	if from_leaderboard == true:
		pass
		from_leaderboard = false
	elif from_leaderboard == false:
		Globals.attempt += 1
		add_score((Globals.namae), final_points)
	btn.grab_focus()
	if Globals.died_from_boat == true:
		if rand == 0 or rand == 1 or rand == 2:
			gmovmsg.text = "how in the world did you sink a boat on the way to work?"
		elif rand == 3 or rand == 4:
			gmovmsg.text = "wait...why were you riding a boat on the way to your corporate 9-5?"
		elif rand == 5:
			gmovmsg.text = "새상에 별놈들 다 있다"
		elif rand == 6:
			var new_num = rng.randi_range(0, 2)
			if new_num == 2:
				gmovmsg.text = "QUEUE THE TITANIC MUSIC"
	elif Globals.died_from_delinq == true:
		gmovmsg.text = "so seems like you were punched to oblivion"
	elif Globals.died_from_photo == true:
		if rand >= 0 and rand <= 3:
			gmovmsg.text = "(in)arguably a corporate job is harder than modeling..."
		elif rand > 3:
			gmovmsg.text = "was the fame too much?"
	elif Globals.died_from_wannabeidol:
		gmovmsg.text = "you know what, understandable. I couldn't bear his singing either."
	elif Globals.died_from_cats:
		gmovmsg.text = "unfortunately you will need to pay taxes in real life as well"
	elif rand == 0:
		gmovmsg.text = "well... that's one way to get to work."
	elif rand == 1:
		gmovmsg.text = "you crossed... the line lol"
	elif rand == 2:
		gmovmsg.text = "take a deep breath and cross again!"
	elif rand == 3:
		gmovmsg.text = "this is why us foreigners get a bad rep"
	elif rand == 4:
		gmovmsg.text = "do you have any idea what you told them?"
	elif rand == 5:
		gmovmsg.text = "your boss is still waiting for you at work..."
	elif rand == 6:
		var new_num = rng.randi_range(0,2)
		if new_num == 2:
			gmovmsg.text = "you got the SUPER SECRET MESSAGE! it's your lucky day!"

func _on_texture_button_pressed() -> void:
	Globals.remember_rand = -1
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_button_pressed() -> void:
	Globals.remember_rand = rand
	if from_leaderboard == true:
		var scene = load("res://scenes/leaderboard.tscn") as PackedScene
		var go = scene.instantiate()
		go.from_gameover = true
		var tree = get_tree()
		var old = tree.current_scene
		tree.root.add_child(go)
		tree.current_scene = go
		if old:
			old.queue_free()
		from_leaderboard = false
	elif from_leaderboard == false:
		var scene = load("res://scenes/leaderboard.tscn") as PackedScene
		var go := scene.instantiate()
		go.final_points = final_points
		go.from_gameover = true
		print(go.final_points)
		var tree = get_tree()
		var old = tree.current_scene
		tree.root.add_child(go)
		tree.current_scene = go
		if old:
			old.queue_free()

func add_score(namae: String, score: int) -> void:
	Globals.leaderboard.append({"name": namae, "score": score})
	sort_leaderboard()
	
func sort_leaderboard() -> void:
	Globals.leaderboard.sort_custom(_sort_by_score)

func _sort_by_score(a, b) -> bool:
	return a["score"] > b["score"]
