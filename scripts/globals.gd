extends Node

var leaderboard = []
var attempt : int = 0
var chosen_character: String = ""
var namae : String = ""
var chosen_gender : int = 0
var spawn_next_boat : bool = true
var died_from_boat : bool = false
var died_from_delinq : bool = false
var died_from_photo : bool = false
var died_from_cats : bool = false
var died_from_wannabeidol : bool = false
var remember_rand: int = -1
var from_options_or_leaderboard: bool = false

func _ready():
	ensure_action_with_key("ui_up", KEY_UP)
	ensure_action_with_key("ui_down", KEY_DOWN)
	ensure_action_with_key("ui_left", KEY_LEFT)
	ensure_action_with_key("ui_right", KEY_RIGHT)
	
	ensure_action_with_key("ui_up", KEY_W)
	ensure_action_with_key("ui_down", KEY_S)
	ensure_action_with_key("ui_left", KEY_A)
	ensure_action_with_key("ui_right", KEY_D)

func ensure_action_with_key(action: String, key: Key) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	var ev := InputEventKey.new()
	ev.physical_keycode = key
	InputMap.action_add_event(action, ev)
