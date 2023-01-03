extends Button

#export(PackedScene) onready var gameModeScene
export(String) onready var gameModeName

func _ready():
	pass

func _pressed():
	var scenePath = "res://" + gameModeName + ".tscn"
	print("Changing scene to ", scenePath)
	get_tree().change_scene(scenePath)
#	get_tree().get_root().add_child(gameModeScene.instance())
#	get_tree().set_current_scene(gameModeScene.instance())
