extends Button

#export(PackedScene) onready var gameModeScene
export(String) var game_mode_name

func _ready():
	self.text = game_mode_name

func _pressed():
	print("Game mode ", game_mode_name, " selected")
	Settings.set_game_mode(game_mode_name)
	
#	var scenePath = "res://" + game_mode_name + ".tscn"
	var scenePath = "res://Game.tscn"
	print("Changing scene to ", scenePath)
	get_tree().change_scene(scenePath)
