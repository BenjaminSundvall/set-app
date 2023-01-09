class_name Card
extends Resource


const SHAPE_INDEX = 0
const COLOR_INDEX = 1
const NUMBER_INDEX = 2
const SHADING_INDEX = 3

export(Array) var features setget ,get_features

var shape setget ,get_shape
var color setget ,get_color
var number setget ,get_number
var shading setget ,get_shading


func _init(new_features: Array) -> void:
	assert(new_features.size() == 4)	# Cards must have four features
	features = new_features

func _to_string() -> String:
	return str(features)


func get_features():
	return features

func get_shape():
	return features[SHAPE_INDEX]

func get_color():
	return features[COLOR_INDEX]

func get_number():
	return features[NUMBER_INDEX]

func get_shading():
	return features[SHADING_INDEX]

func get_id():
	var id = 1 + 27*(get_shading()-1) + 9*(get_shape()-1) + 3*(get_color()-1) + (get_number()-1)
	return id
