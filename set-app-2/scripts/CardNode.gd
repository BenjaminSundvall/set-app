extends Control

var card_button
var highlight
var selection

var card setget set_card	# TODO: Change Resource to Card
var selected: bool = false setget set_selected
var highlighted: bool = false setget set_highlighted

signal card_pressed(card)


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
	
	card_button = $CardButton
	var card_id = card.get_id()
	var image_path
	if 0 < card_id and card_id <= 81:
		image_path = "res://assets/cards/classic/"+str(card_id)+".png"
	else:
		image_path = "res://assets/cards/classic/default.png"
	var card_image = load(image_path)
	card_button.texture_normal = card_image

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
	$Hover.show()


func _on_SwipeHitbox_released() -> void:
	$Hover.hide()
