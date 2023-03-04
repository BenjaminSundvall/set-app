extends Control

#var card_button
var symbol1
var symbol2
var symbol3
var highlight
var selection

var card setget set_card	# TODO: Change Resource to Card
var selected: bool = false setget set_selected
var highlighted: bool = false setget set_highlighted

signal card_pressed(card)

const yellow = "e99910"
const green = "1d742d"
const red = "bd1b3b"

func _ready() -> void:
#	var new_card = Card.new([2, 1, 3, 2])
#	set_card(new_card)
	pass

func _process(delta: float) -> void:
	# TODO: Detect swipes and multitouch
#	if $CardButton.is_hovered():
#		$Hover.show()
#	else:
#		$Hover.hide()
	pass

func set_card(new_card: Card):
	assert(new_card is Card)
	card = new_card
	
	# Set card image
#	card_button = $CardButton
#	var card_id = card.get_id()
#	var image_path
#	if 0 < card_id and card_id <= 81:
#		image_path = "res://assets/cards/classic/"+str(card_id)+".png"
#	else:
#		image_path = "res://assets/cards/classic/default.png"
#	var card_image = load(image_path)
#	card_button.texture_normal = card_image
	
	# Set symbols
	symbol1 = $CenterContainer/SymbolContainer/Symbol1
	symbol2 = $CenterContainer/SymbolContainer/Symbol2
	symbol3 = $CenterContainer/SymbolContainer/Symbol3
	
	# Set shape and shading
	var symbol_path = "res://assets/symbols/custom/"+str(card.shape)+"-"+str(card.shading)+".png"
	var symbol_image = load(symbol_path)
	symbol1.texture = symbol_image
	symbol2.texture = symbol_image
	symbol3.texture = symbol_image
	
	# Set color
	var color = "ffc0cb"
	if card.color == 1:
		color = yellow
	elif card.color == 2:
		color = green
	elif card.color == 3:
		color = red
	symbol1.modulate = Color(color)
	symbol2.modulate = Color(color)
	symbol3.modulate = Color(color)
	
	# Set number
	if card.number == 1:
		symbol1.show()
		symbol2.hide()
		symbol3.hide()
	if card.number == 2:
		symbol1.show()
		symbol2.show()
		symbol3.hide()
	if card.number == 3:
		symbol1.show()
		symbol2.show()
		symbol3.show()

func set_selected(val: bool):
	selected = val
	selection = $Selection	
	if selected:
		selection.show()
	else:
		selection.hide()


func set_highlighted(val: bool):
	highlighted = val
	highlight = $Highlight
	if highlighted:
		highlight.show()
	else:
		highlight.hide()


func _on_CardButton_pressed() -> void:
#	emit_signal("card_pressed", self)
	pass


func _on_SwipeHitbox_pressed() -> void:
	emit_signal("card_pressed", self)
#	$Hover.show()


func _on_SwipeHitbox_released() -> void:
#	$Hover.hide()
	pass
