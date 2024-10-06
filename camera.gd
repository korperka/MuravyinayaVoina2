extends Camera2D

var mouse_start_pos = Vector2.ZERO
var screen_start_position = Vector2.ZERO

var dragging = false

# Reference to the Info node (parent node)
var info_node

func _ready():
	# Assuming that the Info node is the parent of this Camera node.
	info_node = get_parent().get_node("info") # Adjust the path if necessary

func _input(event):
	if event.is_action("drag"):
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		position = zoom * (mouse_start_pos - event.position) + screen_start_position

func _process(delta):
	# Keep the Info node fixed on screen
	if info_node:
		info_node.position = global_position - Vector2(576, 324) 
