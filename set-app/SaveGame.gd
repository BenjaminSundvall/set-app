class_name SaveGame
extends Resource

const SAVE_GAME_PATH := "user://savegame.tres"

export(Dictionary) var highscores = {}
#export(int) var best_time = 9999

func set_highscore(game_mode, score):
	highscores[game_mode] = score

func get_highscore(game_mode):
	if game_mode in highscores:
		return highscores[game_mode]
	else:
		print("Score not saved for game mode \"", str(game_mode), "\"")
		return 0

func reset():
	highscores.clear()

func write_savegame():
	ResourceSaver.save(SAVE_GAME_PATH, self)

static func load_savegame():
	if ResourceLoader.exists(SAVE_GAME_PATH):
		return load(SAVE_GAME_PATH)
	return null
