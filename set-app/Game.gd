extends Control

onready var Card = preload("res://Card.tscn")
onready var Set = preload("res://Set.tscn")

onready var cardGrid = $Table
onready var statsLabel = $TopText/StatsLabel
onready var timerLabel = $TopText/TimerLabel
onready var endGameLabel = $EndGameLabel
onready var latestSets = $LatestSets

var MainMenuPath = "res://MainMenu.tscn"

var savegame = null

var deck = []
var table = []

var selected_cards = []
var sets_on_table = []
var taken_sets = []
var highlighted = false
var highlight_count = 0

var game_duration = 0
var running = true

### Settings #####################################
export(int) var highlight_penalty = 20
export(int) var time_limit = 0
export(int) var set_limit = 10
##################################################

signal game_over


func _ready():
	savegame = SaveGame.load_savegame()
	fill_deck()
	refill_table()
	game_duration = 0
	highlight_count = 0
	get_tree().set_quit_on_go_back(false)


func _process(delta):
	# TODO: Do this somewhere else less often?
	if running:
		game_duration += delta
		timerLabel.text = time_to_string(game_duration)
		if time_limit > 0 and game_duration > time_limit:
			emit_signal("game_over")


func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		emit_signal("game_over")
	elif Input.is_key_pressed(KEY_R):
		print("Clearing savefile...")
		savegame.best_time = 0
		savegame.write_savegame()
		print("Savefile cleared!")


func _notification(notification):    
	if notification == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST: 
		get_tree().change_scene(MainMenuPath)


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
	
	if set_limit > 0 and taken_sets.size() == set_limit:
		emit_signal("game_over")
		refill_table()	# TODO: Change?


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
	highlighted = false
	for card in table:
		card.set_highlighted(false)


func highlight_next():
	if not highlighted:
		highlight_count += 1
		game_duration += highlight_penalty
	
	clear_highlights()
	highlighted = true

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
	taken_set.make_set([selected_cards[0].get_feature_list(),
						selected_cards[1].get_feature_list(),
						selected_cards[2].get_feature_list()],
					   game_duration,
					   highlighted)
	
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
	
	if savegame == null:
		savegame = SaveGame.new()

	if savegame.best_time == 0 or game_duration < savegame.best_time:
		endGameLabel.text = "Time: " + time_to_string(game_duration) + \
							"\nNew best time!" + \
							"\n\nScore: " + str(taken_sets.size()) + \
							"\nHighlighted sets: " + str(highlight_count)
		savegame.best_time = game_duration
		savegame.write_savegame()
	else:
		endGameLabel.text = "Time: " + time_to_string(game_duration) + \
							"\nPrevious best: " + time_to_string(savegame.best_time) + \
							"\n\nScore: " + str(taken_sets.size()) + \
							"\nHighlighted sets: " + str(highlight_count)
	endGameLabel.show()
