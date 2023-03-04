extends Control


var GamePath = "res://scenes/Game.tscn"


func _ready() -> void:
	GameRules.set_mode(GameRules.GameMode.CLASSIC)
	
	var game_mode_label = $PlayButton/ModeLabel
	game_mode_label.text = "Mode: " + GameRules.mode_name


func _on_PlayButton_pressed() -> void:
	get_tree().change_scene(GamePath)


func _on_GamemodeButton_pressed():
	var game_mode = GameRules.game_mode + 1
	if game_mode >= GameRules.GameMode.size():
		game_mode = 1	# Change this to 0 to enable custom mode
	GameRules.set_mode(game_mode)
	
	var game_mode_label = $PlayButton/ModeLabel
	game_mode_label.text = "Mode: " + GameRules.mode_name
