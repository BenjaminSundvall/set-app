extends Control

onready var Card = preload("res://Card.tscn")
onready var cardGrid = $CardGrid
onready var statsLabel = $StatsLabel

var deck = []
var table = []

var selected_cards = []
var sets_on_table = []
var taken_sets = []

export(int) var show_set = false

signal game_over


func _ready():
	fill_deck()
	refill_table()


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
	statsLabel.text = "Deck: " + str(deck.size()) + \
					  "\nScore: " + str(taken_sets.size()) + \
					  "\nSets on board: " + str(sets_on_table.size())
	# TODO: Move this somewhere else?
	clear_highlights()


func refill_table():
	print("Refilling table...")
	# Make sure that there are at least 12 cards on the table
	while table.size() < 12:
		deal_cards()

	# If there are no sets on the table, add three more cards at a time until there is
	find_sets_on_table()
	while not sets_on_table:
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
					print("Found set at ", i+1, " ", j+1, " ", k+1)
					sets_on_table.append(potential_set)
	print("Found ", sets_on_table.size(), " sets!")


func take_set(set):
	if set.size() != 3:
		print("A set must consist of exactly 3 cards! (take_set)")
		return
	
	var taken_set = [selected_cards[0], selected_cards[1], selected_cards[2]]	# TODO: Add statistics here (time taken etc.)
	taken_sets.append(taken_set)		# Add set to list of taken sets
	for card in taken_set:
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


func _on_ShowSetButton_pressed():
	highlight_next()


func _on_RestartButton_pressed():
	get_tree().reload_current_scene()
