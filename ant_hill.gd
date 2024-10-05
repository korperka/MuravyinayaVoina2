extends Node2D

var ant_scene = preload("res://ant.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_ant(pos) -> Ant:
	var instance = ant_scene.instantiate()
	instance.position = pos
	add_child(instance)
	Storage.ants.push_front(instance)
	return instance
	
func remove_ant(instance):
	Storage.ants.erase(instance)
	
