class_name SaveGame
extends Resource

const SAVE_GAME_PATH := "user://savegame.tres"

export(int) var best_time = 9999

func write_savegame():
	ResourceSaver.save(SAVE_GAME_PATH, self)

static func load_savegame():
	if ResourceLoader.exists(SAVE_GAME_PATH):
		return load(SAVE_GAME_PATH)
	return null
