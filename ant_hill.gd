extends Node2D

var ant_scene = preload("res://ant.tscn")
var time_passed: float = 0
var interval: float = 100
var ant_spawn_interval: float = 10.0  # Time in seconds to spawn a new ant

func _ready() -> void:
	ResourcePositions.positions.push_back(self)

func _process(delta: float) -> void:
	time_passed += delta
	
	# Increase resources based on working ants
	if time_passed >= interval / Storage.working_ants:
		Storage.resources += 1
		print("Resources are now ", Storage.resources)
		time_passed = 0
		
		# Upgrade anthill if resource requirements are met
		var index = 0
		for resources in Storage.anthill_updates:
			index += 1
			if Storage.resources == resources:
				update_anthill(index)
	
	# Spawn ants at regular intervals
	ant_spawn_interval -= delta
	if ant_spawn_interval <= 0:
		for i in range(Storage.working_ants / ResourcePositions.resources.size()):
			spawn_ant($Sprite2D.position)
		ant_spawn_interval = 10.0  # Reset the spawn interval

func find_random_leaf_pile() -> Vector2:
	var available_leaf_piles = []

	# Collect leaf piles with available workers from the global list
	for leaf: Leaves in ResourcePositions.resources:
		if leaf.workers > 0:
			available_leaf_piles.append(leaf.position)
			print("Available leaf pile found at position:", leaf.position, "with workers:", leaf.workers)

	# Select a random leaf pile if available
	if available_leaf_piles.size() > 0:
		var random_index = randi() % available_leaf_piles.size()
		print("Random leaf pile selected:", available_leaf_piles[random_index])
		return available_leaf_piles[random_index]
	
	print("No available leaf piles found")
	return Vector2.ZERO

func spawn_ant(pos: Vector2) -> Ant:
	var instance_scene = ant_scene.instantiate()
	var ant_instance = instance_scene.get_node("CharacterBody2D") as Ant
	
	if ant_instance != null:
		ant_instance.position = pos
		add_child(instance_scene)
		Storage.ants.push_front(ant_instance)
		
		# Assign the ant a task to collect resources from a random leaf pile
		var random_leaf_position = find_random_leaf_pile()
		if random_leaf_position != Vector2.ZERO:
			ant_instance.move_to_target_return(random_leaf_position)
		else:
			print("No available leaf piles to collect from")
	else:
		print("Error: Ant node could not be instantiated")
	
	return ant_instance

func get_leaf_instance(position: Vector2) -> Leaves:
	# Assuming leaves are added to the scene tree, find the leaf instance at the given position
	for leaf in get_children():
		if leaf.position == position:
			return leaf as Leaves
	return null

func update_anthill(level):
	Storage.anthill_level += 1
	Storage.ants_count *= 2
	
	# Increase the size of the anthill sprite as an upgrade
	$Sprite2D.scale *= Vector2(1.5, 1.5)
