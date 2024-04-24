#class_name GameRules
#extends Resource
extends Node

enum GameMode {CUSTOM=0, CLASSIC=1, SPRINT=2, TIMED=3}

@export var game_mode: int

@export var mode_name: String
@export var time_limit: int
@export var set_limit: int
@export var hint_penalty: int
@export var reveal_penalty: int
#export(bool) var audo_deal_cards
@export var enable_hints: bool
#export(bool) var enable_shape_feature
#export(bool) var enable_color_feature
#export(bool) var enable_number_feature
#export(bool) var enable_shading_feature

#func _init(mode: int) -> void:
func set_mode(mode: int) -> void:
	game_mode = mode
	
	# Hard coded game modes
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
