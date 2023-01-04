extends Control

const shapeMap  = {-1 : "N/A", 0 : "Different", 1 : "Squiggle", 2 : "Diamond", 3 : "Oval"}
const colorMap  = {-1 : "N/A", 0 : "Different", 1 : "Red",      2 : "Purple",  3 : "Green"}
const numberMap = {-1 : "N/A", 0 : "Different", 1 : "Ones",     2 : "Twos",    3 : "Threes"}
const shadigMap = {-1 : "N/A", 0 : "Different", 1 : "Solid",    2 : "Striped", 3 : "Outlined"}

export(int) var set_shapes = -1
export(int) var set_colors = -1
export(int) var set_numbers = -1
export(int) var set_shadings = -1
export(bool) var set_highlighted = false

var cards_in_set = []

func make_set(cards, timestamp, highlighted):
	if cards.size() != 3:
		print("Invalid number of cards!")
		return
	
	cards_in_set = cards
	
	###################################################
	# TODO: Ugly code! Remove duplicate code!
	var card_1_shape = cards_in_set[0][0]
	var card_2_shape = cards_in_set[1][0]
	if card_1_shape == card_2_shape:
		set_shapes = card_1_shape
	else:
		set_shapes = 0	# Shapes are different
	
	# TODO: Ugly code! Remove duplicate code!
	var card_1_color = cards_in_set[0][1]
	var card_2_color = cards_in_set[1][1]
	if card_1_color == card_2_color:
		set_colors = card_1_color
	else:
		set_colors = 0	# Shapes are different

	# TODO: Ugly code! Remove duplicate code!
	var card_1_number = cards_in_set[0][2]
	var card_2_number = cards_in_set[1][2]
	if card_1_number == card_2_shape:
		set_numbers = card_1_number
	else:
		set_numbers = 0	# Shapes are different
	
	# TODO: Ugly code! Remove duplicate code!
	var card_1_shading = cards_in_set[0][3]
	var card_2_shading = cards_in_set[1][3]
	if card_1_shading == card_2_shading:
		set_shadings = card_1_shading
	else:
		set_shadings = 0	# Shapes are different
	###################################################
	
	var card_1_image = $VBoxContainer/Cards/Card1Container/Card1Image
	var card_2_image = $VBoxContainer/Cards/Card2Container/Card2Image
	var card_3_image = $VBoxContainer/Cards/Card3Container/Card3Image
	var card_images = [card_1_image, card_2_image, card_3_image]
	var timestamp_button = $VBoxContainer/TimestampButton
	
	for i in cards_in_set.size():
		var card = cards_in_set[i]
		
		var shape = card[0]
		var color = card[1]
		var number = card[2]
		var shading = card[3]
		
		var image
		if shape != 0 and color != 0 and number != 0 and shading != 0:
			image = load("res://assets/cards/"+str(shape)+"-"+str(color)+"-"+str(number)+"-"+str(shading)+".png")
		else:
			print("Invalid card. Adding default image")
			image = load("res://assets/cards/default.png")
		card_images[i].texture = image
	
	var minutes = int(timestamp / 60)
	var seconds = int(timestamp) % 60
	timestamp_button.text = "%d:%02d" % [minutes, seconds]
	
	var highlightBorder = $VBoxContainer/TimestampButton/HighlightBorder
	set_highlighted = highlighted
	if set_highlighted:
		highlightBorder.show()


func _ready():
	pass
