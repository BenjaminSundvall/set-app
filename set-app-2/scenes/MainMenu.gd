extends Control


var GamePath = "res://scenes/Game.tscn"


func _ready() -> void:
	pass


func _on_PlayButton_pressed() -> void:
	get_tree().change_scene(GamePath)
