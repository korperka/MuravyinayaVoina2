extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Update the text by directly setting it
	var formatted_text = "Resources: {resources}\nAnts: {ants}\nLevel: {level}".format({
		"resources": Storage.resources,
		"ants": Storage.ants_count,
		"level": Storage.anthill_level
	})

	# Set the new text
	text = formatted_text
