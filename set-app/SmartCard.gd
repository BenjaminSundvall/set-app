class_name SmartCard
extends Resource

export var shape: int
const SHAPE_COUNT = 3
export var color: int
export var number: int
export var shading: int


func _init(card: Array) -> void:
	if not is_valid_card(card):
		return
	

func _init(card_shape: int, card_color: int, card_number: int, card_shading: int):
	shape = card_shape

func is_valid_card(card: Array) -> bool:
	if card.size() != 4:
		print("Invalid number of features on card: ", card.size())
		return false
	return true

func _ready() -> void:
	pass
