extends Control

onready var MainMenu = preload("res://MainMenu.tscn")

onready var Card = preload("res://Card.tscn")
onready var Set = preload("res://Set.tscn")
onready var cardGrid = $Table
onready var statsLabel = $TopText/StatsLabel
onready var timerLabel = $TopText/TimerLabel
onready var endGameLabel = $EndGameLabel
onready var latestSets = $LatestSets


var deck = []
var table = []

var selected_cards = []
var sets_on_table = []
var taken_sets = []

var game_duration = 0
var running = true

signal game_over


func _ready():
	fill_deck()
	refill_table()
	deck.clear()	# TODO: For debugging. Remove this!
	game_duration = 0


func _process(delta):
	# TODO: Do this somewhere else less often?
	if running:
		game_duration += delta
		timerLabel.text = "Time: " + time_to_string(game_duration)


func _input(ev):
	if Input.is_key_pressed(KEY_ESCAPE):
		emit_signal("game_over")


func fill_deck():
	for i in range(1,4):
		for j in range(1,4):
			for k in range(1,4):
				for l in range(1,4):
#					var new_card = preload("res://Card.tscn").instance()
					var new_card = Card.instance()
					new_card.shape = i
					new_card.color = j
					new_card.number = k
					new_card.shading = l
					new_card.game = self	# TODO: Circular reference! Not nice!
					deck.append(new_card)
	randomize()
	deck.shuffle()


func deal_cards():
	print("Dealing cards...")
	for i in range(3):
		if deck.size() == 0:
			print("Deck is empty!")
			emit_signal("game_over")
			return
		var card = deck.pop_front()
		table.append(card)
		cardGrid.add_child(card)
	# TODO: Move this somewhere else?
	clear_highlights()


func refill_table():
	print("Refilling table...")
	# Make sure that there are at least 12 cards on the table
	while table.size() < 12:
		if deck.empty():
			break
		deal_cards()

	# If there are no sets on the table, add three more cards at a time until there is
	find_sets_on_table()
	while not sets_on_table:
		if deck.empty():
			emit_signal("game_over")
			return
		deal_cards()
		find_sets_on_table()


func find_sets_on_table():
	sets_on_table = []
	var card_count = table.size()
	for i in range(card_count):
		for j in range(i+1, card_count):
			for k in range(j+1, card_count):
				var potential_set = [table[i], table[j], table[k]]
				if is_set(potential_set):
					sets_on_table.append(potential_set)
	statsLabel.text = "Deck: " + str(deck.size()) + \
					  "\nScore: " + str(taken_sets.size()) + \
					  "\nSets: " + str(sets_on_table.size())


func take_set(set):
	if set.size() != 3:
		print("A set must consist of exactly 3 cards! (take_set)")
		return
	
	
	add_set_to_recent([selected_cards[0].get_feature_list(), \
					   selected_cards[1].get_feature_list(), \
					   selected_cards[2].get_feature_list()])
	
	for card in selected_cards:
		cardGrid.remove_child(card)		# Remove the taken cards from scene
		table.erase(card)


func select_card(card):
	if card == null:
		print("Tried to select null card!")
		return
	
	if card in selected_cards:
		card.set_selected(false)
		selected_cards.erase(card)		# Deselect card
	else:
		card.set_selected(true)
		selected_cards.append(card)		# Select card
		if selected_cards.size() == 3:
			if is_set(selected_cards):
				take_set(selected_cards)
				refill_table()
			deselect_all()		# Clear selection


func deselect_all():
	for card in selected_cards:
		card.set_selected(false)
	selected_cards.clear()


func is_set(potential_set):
	if potential_set.size() != 3:
		print("A set must consist of exactly 3 cards! (is_set)")
		return false

	var card_1_features = potential_set[0].get_feature_list()
	var card_2_features = potential_set[1].get_feature_list()
	var card_3_features = potential_set[2].get_feature_list()

	for feat_num in range(4):
		if (card_1_features[feat_num] == card_2_features[feat_num]) and (card_1_features[feat_num] == card_3_features[feat_num]) and (card_2_features[feat_num] == card_3_features[feat_num]):
			pass
		elif (card_1_features[feat_num] != card_2_features[feat_num]) and (card_1_features[feat_num] != card_3_features[feat_num]) and (card_2_features[feat_num] != card_3_features[feat_num]):
			pass
		else:
			return false
	return true     # If all features are ok, return True...


func clear_highlights():
	for card in table:
		card.set_highlighted(false)


func highlight_next():
	clear_highlights()
	sets_on_table.push_back(sets_on_table.pop_front())
	for card in sets_on_table.front():
		card.set_highlighted(true)


func time_to_string(time):
	var minutes = int(time / 60)
	var seconds = int(time) % 60
	return "%d:%02d" % [minutes, seconds]


func add_set_to_recent(set):
	if set.size() != 3:
		print("Set must be of size 3! (add_set_to_recent)")
		return
	
	var taken_set = Set.instance()
	taken_set.make_set([selected_cards[0].get_feature_list(), \
											 selected_cards[1].get_feature_list(), \
											 selected_cards[2].get_feature_list()], \
											game_duration)
	
	taken_sets.append(taken_set)	# Used for statistics
	
	# Show set in recents list
	latestSets.add_child(taken_set)
	if latestSets.get_child_count() > 3:
		latestSets.remove_child(latestSets.get_child(0))


func _on_ShowSetButton_pressed():
	highlight_next()


func _on_RestartButton_pressed():
	get_tree().reload_current_scene()


func _on_NormalGame_game_over():
	running = false
	var savegame = SaveGame.load_savegame()
	if savegame == null:
		print("Creating new save...")
		savegame = SaveGame.new()
	
	print("Loaded highscore ", time_to_string(savegame.best_time))
	print("Current time ", time_to_string(game_duration))
	if game_duration < savegame.best_time:
		print("New highscore: ", game_duration)
		endGameLabel.text = "Time: " + time_to_string(game_duration) + \
							"\nNew best time!" + \
							"\n\nScore: " + str(taken_sets.size())
		savegame.best_time = game_duration
		savegame.write_savegame()
	else:
		endGameLabel.text = "Time: " + time_to_string(game_duration) + \
							"\nPrevious best: " + time_to_string(savegame.best_time) + \
							"\n\nScore: " + str(taken_sets.size())
	endGameLabel.show()


###################################################################

#var savegame = File.new() #file
#var savegame = "user://savegame.tres" #place of the file
#var save_data = {"highscore": 0} #variable to store data
#
#func create_save():
#   savegame.open(save_path, File.WRITE)
#   savegame.store_var(save_data)
#   savegame.close()
#
##func _ready():
##  if not savegame.file_exists(save_path):
##    create_save()
#
#func save(high_score):    
#   save_data["highscore"] = high_score #data to save
#   savegame.open(save_path, File.WRITE) #open file to write
#   savegame.store_var(save_data) #store the data
#   savegame.close() # close the file
#
#func read_savegame():
#   savegame.open(save_path, File.READ) #open the file
#   save_data = savegame.get_var() #get the value
#   savegame.close() #close the file
#   return save_data["highscore"] #return the value
