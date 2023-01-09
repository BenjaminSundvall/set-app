class_name GameStats
extends Resource


export(String) var player setget set_player
export(int) var game_mode setget set_game_mode

export(Array) var sets setget set_sets, get_sets
export(float) var start_time setget set_start_time
export(float) var end_time setget set_end_time
export(float) var duration setget set_duration



func _init(game_mode, player="N/A") -> void:
	self.player = player
	self.game_mode = game_mode
	self.sets = []
	self.start_time = Time.get_unix_time_from_system()
	self.end_time = -1
	self.duration = 0

# TODO: Make add_set() function

func set_sets(new_sets: Array):
	# TODO: Check that the sets are valid?
	sets = new_sets

func get_sets():
	return sets

func set_player(name: String):
	# TODO: Limit player name length
	player = name

func set_game_mode(mode: int):
	# TODO: Check that the game mode exists
	game_mode = mode

func set_start_time(time: float):
	start_time = time

func set_end_time(time: float):
	if time < start_time:
		end_time = -1
	else:
		end_time = time

func set_duration(time: float):
	duration = time



func get_set_count() -> int:
	assert(sets != null)
	return sets.size()

func get_highlight_count() -> int:
	var highlight_count = 0
	for set in sets:
		if set.highlighted:
			highlight_count += 1
	return highlight_count
	
