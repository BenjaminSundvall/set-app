class_name Set
extends Resource


export(Array) var cards setget ,get_cards
export(float) var time
export(bool) var highlighted = false


func _init(card_1: Resource, card_2: Resource, card_3: Resource) -> void:
	cards = [card_1, card_2, card_3]

func get_cards() -> Array:
	return cards

func is_set() -> bool:
	var card_1_features = cards[0].get_features()
	var card_2_features = cards[1].get_features()
	var card_3_features = cards[2].get_features()
	
	for i in range(4):
		if card_1_features[i] == card_2_features[i] and card_2_features[i] == card_3_features[i]:
			continue
		elif card_1_features[i] != card_2_features[i] and card_1_features[i] != card_3_features[i] and card_2_features[i] != card_3_features[i]:
			continue
		else:
			return false
	return true
