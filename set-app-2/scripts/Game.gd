extends Control


onready var CardNode = preload("res://scenes/CardNode.tscn")
var MainMenuPath = "res://scenes/MainMenu.tscn"

onready var menu_button = $UIElements/TopRow/MenuButtonContainer/MenuButton
onready var timer_label = $UIElements/TopRow/TimeContainer/TimerLabel
onready var score_label = $UIElements/TopRow/ScoreContainer/ScoreLabel

onready var game_mode_label = $UIElements/GameInfoLabels/GameModeLabel
onready var set_count_label = $UIElements/GameInfoLabels/SetCountLabel

onready var table = $UIElements/TableNode

onready var restart_button = $UIElements/BottomRow/RestartButton
onready var highlight_button = $UIElements/BottomRow/HighlightButton

onready var game_over_window = $UIElements/TableNode/GameOverWindow
onready var game_over_label = $UIElements/TableNode/GameOverWindow/GameOverLabel

var deck: Array = []
var selected_card_nodes: Array = []
var sets_on_table: Array = []
var running: bool = true
var highlighted: bool = false

var game_stats: Resource
var game_rules: Resource

signal game_over(cause)


func _ready() -> void:
	var game_mode = GameRules.GameMode.SPRINT
	game_stats = GameStats.new(game_mode)
	game_rules = GameRules.new(game_mode)
	game_mode_label.text = "   Mode: " + game_rules.mode_name
	fill_deck()
	refill_table()


func _process(delta: float) -> void:
	if running:
		game_stats.duration += delta	# Increment game duration
		if game_rules.time_limit > 0 and game_stats.duration > game_rules.time_limit:
			emit_signal("game_over", "Time limit reached")
			
		var time = game_stats.duration
		if game_rules.time_limit > 0:
			time = game_rules.time_limit - game_stats.duration
		var minutes = int(time / 60)
		var seconds = int(time) % 60
		timer_label.text = "%d:%02d" % [minutes, seconds]


func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		emit_signal("game_over", "Escape key pressed")


func fill_deck() -> void:
	print("Filling deck...")
	for shp in range(1,4):
		for col in range(1,4):
			for num in range(1,4):
				for shd in range(1,4):
					var new_card = Card.new([shp, col, num, shd])
					deck.append(new_card)
	randomize()
	deck.shuffle()


func refill_table() -> void:
	print("Refilling table...")
	while deck.size() > 0 and table.node_count < 12:
		deal_card()
	
	update_sets_on_table()
	while sets_on_table.size() == 0:
		print("No sets on table! Dealing 3 new cards...")
		if deck.size() < 3:
			emit_signal("game_over", "Out of cards")
			return
		for i in range(3):
			deal_card()
		update_sets_on_table()


func update_sets_on_table() -> void:
	sets_on_table = []
	var card_count = table.node_count
	for i in range(card_count):
		for j in range(i+1, card_count):
			for k in range(j+1, card_count):
				var potential_set = Set.new(table.get_node_at(i).card, table.get_node_at(j).card, table.get_node_at(k).card)
				if potential_set.is_set():
					sets_on_table.append([table.get_node_at(i), table.get_node_at(j), table.get_node_at(k)])
	set_count_label.text = "On Table: %d   " % [sets_on_table.size()]


func deal_card() -> void:
	var card = deck.pop_front()
	var new_card_node = CardNode.instance()
	new_card_node.set_card(card)
	table.add_node(new_card_node)
	new_card_node.connect("card_pressed", self, "_on_card_pressed")


func try_take_selected() -> void:
	var potential_set = Set.new(selected_card_nodes[0].card, selected_card_nodes[1].card, selected_card_nodes[2].card)
	potential_set.highlighted = highlighted
	if potential_set.is_set():
		clear_highlights()
		for old_card_node in selected_card_nodes:
			if table.node_count > 12:
				table.remove_node(old_card_node)
			else:
				var new_card_node = CardNode.instance()
				new_card_node.set_card(deck.pop_front())
				table.replace_node(old_card_node, new_card_node)
				new_card_node.connect("card_pressed", self, "_on_card_pressed")
		refill_table()
		game_stats.sets.append(potential_set)
		score_label.text = "%d Sets" % [game_stats.get_set_count()]
		if game_rules.set_limit > 0 and game_stats.get_set_count() >= game_rules.set_limit:
			emit_signal("game_over", "Set limit reached")
	clear_selection()


func clear_selection() -> void:
	for card_node in selected_card_nodes:
		card_node.selected = false
	selected_card_nodes.clear()


func highlight_next_set() -> void:
	clear_highlights()
	highlighted = true
	var next_set = sets_on_table.pop_front()
	for card_node in next_set:
		card_node.highlighted = true
	sets_on_table.push_back(next_set)


func clear_highlights() -> void:
	highlighted = false
	for set in sets_on_table:
		for card_node in set:
			card_node.highlighted = false


func _on_card_pressed(card_node: Node):
	if card_node.selected:
		card_node.selected = false
		selected_card_nodes.erase(card_node)
	else:
		card_node.selected = true
		selected_card_nodes.append(card_node)
		if selected_card_nodes.size() == 3:
			try_take_selected()


func _on_MenuButton_pressed() -> void:
	get_tree().change_scene(MainMenuPath)


func _on_RestartButton_pressed() -> void:
	get_tree().reload_current_scene()


func _on_HighlightButton_pressed() -> void:
	highlight_next_set()


func _on_Game_game_over(cause) -> void:
	running = false
	print("Game over!")
	print("Cause: ", cause)
	var minutes = int(game_stats.duration / 60)
	var seconds = int(game_stats.duration) % 60
	game_over_label.text = "Game Over!\n" + \
						 "\nMode: " + game_rules.mode_name + \
						 "\nTime: %d:%02d" % [minutes, seconds] + \
						 "\nScore: %d" % [game_stats.get_set_count()] + \
						 "\nHighlights: %d" % [game_stats.get_highlight_count()]
	game_over_window.show()

