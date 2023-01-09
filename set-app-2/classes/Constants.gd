extends Node

enum ShapeFeature {SQUIGGLE = 1, DIAMOND = 2, OVAL = 3}
enum ColorFeature {RED = 1, BLUE = 2, GREEN = 3}
enum NumberFeature {ONE = 1, TWO = 2, THREE = 3}
enum ShadingFeature {SOLID = 1, STRIPED = 2, OPEN = 3}

const SHAPE = 0
const COLOR = 1
const NUMBER = 2
const SHADING = 3

const SQUIGGLE = 1
const DIAMOND = 2
const OVAL = 3

const RED = 1
const BLUE = 2
const GREEN = 3

const ONE = 1
const TWO = 2
const THREE = 3

const SOLID = 1
const STRIPED = 2
const OPEN = 3

const SHAPE_NAMES = {SQUIGGLE : "squiggle",
					 DIAMOND  : "diamond",
					 OVAL     : "oval"}
const COLOR_NAMES = {RED   : "red",
					 BLUE  : "blue",
					 GREEN : "green"}
const NUMBER_NAMES = {ONE   : "one",
					  TWO   : "two",
					  THREE : "three"}
const SHADING_NAMES = {SOLID   : "solid",
					   STRIPED : "striped",
					   OPEN    : "open"}

func shape2str(shape):
	if shape in SHAPE_NAMES:
		return SHAPE_NAMES[shape]
	return "unknown shape"

func color2str(color):
	if color in COLOR_NAMES:
		return COLOR_NAMES[color]
	return "unknown color"

func number2str(number):
	if number in NUMBER_NAMES:
		return NUMBER_NAMES[number]
	return "unknown number"

func shading2str(shading):
	if shading in SHADING_NAMES:
		return SHADING_NAMES[shading]
	return "unknown shading"
