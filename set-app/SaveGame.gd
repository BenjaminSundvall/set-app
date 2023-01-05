class_name SaveGame
extends Resource

const SAVE_GAME_PATH := "user://savegame.tres"

const featureMap = {0 : "Shape", 1 : "Color", 2 : "Number", 3 : "Shading"}

const shapeMap   = {-1 : "N/A", 0 : "Different", 1 : "Squiggle", 2 : "Diamond", 3 : "Oval"}
const colorMap   = {-1 : "N/A", 0 : "Different", 1 : "Red",      2 : "Purple",  3 : "Green"}
const numberMap  = {-1 : "N/A", 0 : "Different", 1 : "Ones",     2 : "Twos",    3 : "Threes"}
const shadingMap = {-1 : "N/A", 0 : "Different", 1 : "Solid",    2 : "Striped", 3 : "Outlined"}


export(Dictionary) var highscores = {}
export(Array) var history = []
#export(int) var best_time = 9999


func set_highscore(game_mode, score):
	highscores[game_mode] = score

func get_highscore(game_mode):
	if game_mode in highscores:
		return highscores[game_mode]
	else:
		print("Score not saved for game mode \"", str(game_mode), "\"")
		return 0


func add_to_history(set, highlighted, time):
	var data = [set, highlighted, time]
	history.append(data)

func get_average_time(feature_number, value):
	var total_time = 0
	var set_count = 0
	
	for data in history:
		var set = data[0]
		var highlighted = data[1]
		var time = data[2]
		
		var card_1 = set[0]
		var card_2 = set[1]
#		var card_3 = set[2]
		
#		# Exclude highlighted sets from average
#		if highlighted:
#			continue
		
		if card_1[feature_number] == card_2[feature_number] and card_1[feature_number] == value:
			total_time += time
			set_count += 1
	
	if set_count == 0:
		return -1
	
	return total_time / set_count


# TODO: Move this somewhere else!
func average_times_to_string():
	var string = "Average times:"
	for feature in range(4):
		for value in range(1,4):
			var val_str
			if featureMap[feature] == "Shape":
				val_str = shapeMap[value]
			elif featureMap[feature] == "Color":
				val_str = colorMap[value]
			elif featureMap[feature] == "Number":
				val_str = numberMap[value]
			if featureMap[feature] == "Shading":
				val_str = shadingMap[value]
			string += "\n\n" + val_str + " avg time: " + str(get_average_time(feature, value))
	return string


func reset():
	highscores.clear()
	history.clear()

func write_savegame():
	ResourceSaver.save(SAVE_GAME_PATH, self)

static func load_savegame():
	if ResourceLoader.exists(SAVE_GAME_PATH):
		return load(SAVE_GAME_PATH)
	return null
