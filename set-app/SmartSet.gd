class_name SmartSet
extends Resource

const FEATURE_COUNT = 4			# Shape, color, number, and size
const OPTIONS_PER_FEATURE = 3	# E.g. red, purple, and green
const FEATURE_SUM = OPTIONS_PER_FEATURE * (OPTIONS_PER_FEATURE - 1) / 2		# Triangular number formula

const MAX_TIME_PER_SET = 1023	# 2^10 seconds (10b storage size)

#const SHAPE = 0
#const COLOR = 1
#const NUMBER = 2
#const SHADING = 3

#enum SetShape   {SQUIGGLE = 1, DIAMOND = 2, OVAL     = 3}
#enum SetColor   {RED      = 1, PURPLE  = 2, GREEN    = 3}
#enum SetNumber  {ONE      = 1, TWO     = 2, THREE    = 3}
#enum SetShading {SOLID    = 1, STRIPED = 2, OUTLINED = 3}

export var first_card: Array = [] setget set_first_card, get_first_card
export var second_card: Array = [] setget set_second_card, get_second_card
export var third_card: Array = [] setget set_third_card, get_third_card
export var take_time: int = 0 setget set_take_time, get_take_time


func set_first_card(card: Array) -> void:
	if is_valid_card(card):
		first_card = card

func get_first_card() -> Array:
	return first_card


func set_second_card(card: Array) -> void:
	if is_valid_card(card):
		second_card = card
	
func get_second_card() -> Array:
	return second_card


func set_third_card(card: Array) -> void:
	if is_valid_card(card):
		third_card = card

func get_third_card() -> Array:
	return third_card


func set_take_time(time) -> void:
	if time > MAX_TIME_PER_SET:
		print("Time exceeded max time! (time=", time, ")")
		time = 0
	take_time = clamp(time, 0, MAX_TIME_PER_SET)	# TODO: Maybe unneccessary?

func get_take_time() -> int:
	return take_time


func _init(first: Array, second: Array, third: Array = []) -> void:
	if not is_valid_card(first) or not is_valid_card(second):
		print("ERROR!")
		return
	
	first_card = first
	second_card = second
	if is_valid_card(third):
		third_card = third
	else:
		third_card = infer_card(first, second)


#func _ready() -> void:
#	pass


func is_valid_card(card: Array) -> bool:
	# Check that the card has the right number of features
	if card.size() != FEATURE_COUNT:
		print("Invalid number of features on card: ", card.size())
		return false
	
	# Check that all the features on the card ar valid
	for feature in card:
		if feature <= 0 or feature > OPTIONS_PER_FEATURE:
			print("Invalid feature ", feature, " in card ", card)
			return false
	
	return true


func infer_card(first: Array, second: Array) -> Array:
	if first.size() != FEATURE_COUNT or second.size() != FEATURE_COUNT:
		print("Invalid feature count! Returning empty array...")
		return []
	
	var third: Array = []
	
	# Set all features of the third card
	for feature in range(FEATURE_COUNT):
		if first[feature] == second[feature]:
			# The feature is the same on all cards
			third.append(first[feature])
		else:
			# The feature is different on all cards
			third.append(FEATURE_SUM - (first[feature] + second[feature]))
	
	return third


func set2bits():		# TODO: return type?
	pass
	

static func bits2set(bits) -> SmartSet:
	return null
