extends Node2D

var ant_scene = preload("res://ant.tscn")

var time_passed: float = 0
var interval: float = 150

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_passed += delta
	if time_passed >= interval / Storage.working_ants:
		Storage.resources += 1
		print("Resources are now ", Storage.resources)
		time_passed = 0
		
		var index = 0
		for resources in Storage.anthill_updates:
			index += 1
			if Storage.resources == resources:
				update_anthill(index)
				

func spawn_ant(pos) -> Ant:
	var instance = ant_scene.instantiate()
	instance.position = pos
	add_child(instance)
	Storage.ants.push_front(instance)
	return instance
	
func remove_ant(instance):
	Storage.ants.erase(instance)

func update_anthill(level):
	Storage.anthill_level += 1
	Storage.ants_count *= 2
	
	#TODO изменение текстурки
	$Sprite2D.scale *= Vector2(1.5, 1.5)
