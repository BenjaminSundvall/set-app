class_name GameRules
extends Resource

enum GameMode {CUSTOM=0, CLASSIC=1, SPRINT=2, TIMED=3}

export(int) var game_mode

export(String) var mode_name
export(int) var time_limit
export(int) var set_limit
export(int) var hint_penalty
export(int) var reveal_penalty
#export(bool) var audodeal_cards
export(bool) var enable_hints
#export(bool) var enable_shape_feature
#export(bool) var enable_color_feature
#export(bool) var enable_number_feature
#export(bool) var enable_shading_feature

func _init(mode: int) -> void:
	game_mode = mode
	if game_mode == GameMode.CUSTOM:
		mode_name = "Custom"
		time_limit = 0
		set_limit = 0
		hint_penalty = 0
		reveal_penalty = 0
		enable_hints = true
	elif game_mode == GameMode.CLASSIC:
		mode_name = "Classic"
		time_limit = 0
		set_limit = 0
		hint_penalty = 10
		reveal_penalty = 20
		enable_hints = true
	elif game_mode == GameMode.SPRINT:
		mode_name = "Sprint"
		time_limit = 0
		set_limit = 10
		hint_penalty = 10
		reveal_penalty = 20
		enable_hints = true
	elif game_mode == GameMode.TIMED:
		mode_name = "Timed"
		time_limit = 60
		set_limit = 0
		hint_penalty = 10
		reveal_penalty = 20
		enable_hints = true
	else:
		print("Invalid game mode: %d!" % [game_mode])
