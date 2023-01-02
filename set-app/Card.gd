extends TextureButton

class_name Card

export(int) var shape = 0 setget set_shape
export(int) var color = 0 setget set_color
export(int) var number = 0 setget set_number
export(int) var shading = 0 setget set_shading

export(bool) var selected = false setget set_selected
export(bool) var highlighted = false setget set_highlighted

var face = null
onready var selectionBorder = $SelectionBorder
onready var highlightBorder = $HighlightBorder

var game = null

func set_shape(value):
	shape = clamp(value, 0, 3)
	update_image()

func set_color(value):
	color = clamp(value, 0, 3)
	update_image()

func set_number(value):
	number = clamp(value, 0, 3)
	update_image()

func set_shading(value):
	shading = clamp(value, 0, 3)
	update_image()

func set_selected(show):
	selected = show
	if show:
		selectionBorder.show()
	else:
		selectionBorder.hide()

func set_highlighted(show):
	highlighted = show
	if show:
		highlightBorder.show()
	else:
		highlightBorder.hide()

func get_feature_list():
	return [shape, color, number, shading]

func _ready():
	pass

#func _init(shp, col, num, shd):
#	print("init")
#	shape = shp
#	color = col
#	number = num
#	shading = shd
#	update_image()


func _on_Card_pressed():
	if game != null:
		game.select_card(self)


func update_image():
	if shape != 0 and color != 0 and number != 0 and shading != 0:
		self.face = load("res://assets/cards/"+str(shape)+"-"+str(color)+"-"+str(number)+"-"+str(shading)+".png")
	else:
		self.face = load("res://assets/cards/default.png")
	set_normal_texture(self.face)
