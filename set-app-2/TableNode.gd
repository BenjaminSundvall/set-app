extends Control

const WIDTH = 6
const HEIGHT = 3
const MAX_CAPACITY = WIDTH * HEIGHT

var node_count = 0

onready var main_grid = $MainGrid


func _ready() -> void:
	pass


func add_node(new_node: Node) -> void:
#	print("Adding node ", new_node, "...")
	if main_grid.get_child_count() < MAX_CAPACITY:
		main_grid.add_child(new_node)
		node_count += 1
	else:
		print("Table full!")


func replace_node(old_node: Node, new_node: Node) -> void:
#	print("Replacing node ", old_node, " with ", new_node, "...")
	var parent = old_node.get_parent()
	var old_node_index = old_node.get_index()
	parent.remove_child(old_node)
	parent.add_child(new_node)
	parent.move_child(new_node, old_node_index)


func remove_node(old_node: Node) -> void:
#	print("Removing node ", old_node, "...")
	node_count -= 1
	var parent = old_node.get_parent()
	parent.remove_child(old_node)


func get_node_at(index: int) -> Node:
	if index >= main_grid.get_child_count():
		return null
	
	return main_grid.get_child(index)
