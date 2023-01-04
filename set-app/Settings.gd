#class_name Settings
extends Node

export(String) var game_mode = "" setget set_game_mode
var highlight_penalty = 0
var score_limit = 0
var time_limit = 0

func set_game_mode(mode):
	game_mode = mode
	print("Set game mode to ", game_mode)
	
	if game_mode == "Normal":
		highlight_penalty = 20
		score_limit = 0
		time_limit = 0
	elif game_mode == "Find 10":
		highlight_penalty = 20
		score_limit = 10
		time_limit = 0
	elif game_mode == "1 Minute":
		highlight_penalty = 20
		score_limit = 0
		time_limit = 60
	elif game_mode == "2 Minutes":
		highlight_penalty = 20
		score_limit = 0
		time_limit = 120
	else:
		highlight_penalty = 20
		score_limit = 0
		time_limit = 0
