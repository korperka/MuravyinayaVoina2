extends Node2D

# Load the scene of the object you want to copy
var object_scene = preload("res://leaves.tscn")
var button_scene = preload("res://buttons.tscn")  # Загрузка сцены кнопок

# Number of objects to create
var number_of_objects = 50
var min_spawn_distance = 200
var max_iterations = 100

var object_scenes = [preload("res://grassTile1.tscn"), preload("res://grassTile2.tscn"), preload("res://grassTile3.tscn"), preload("res://grassTile4.tscn")]

var rng = RandomNumberGenerator.new()

func _floor():
	# Number of objects to create
	var viewport_size = get_viewport().get_size()
	var startX = -1*viewport_size.x*2
	var startY = -1*viewport_size.y*2
	
	while startX<viewport_size.x*2:
		startX += 32;
		while startY<viewport_size.y*2:
			startY += 32
			randomize()
			var r = int(rng.randf_range(0, 4))
			var instance = object_scenes[r].instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
			 # Randomly position the instance within the screen area
			var pos = Vector2(startX, startY)
			instance.position = pos
			add_child(instance)
		startY = -1*viewport_size.y*2


func _ready():
	var viewport_size = get_window().size
	var random_positions: Array[Vector2] = []
	var size = Vector2(viewport_size.x * 2 + 1000, viewport_size.y * 2 + 600)
	
	_floor()
	
	for i in range(number_of_objects):
		var iterations = 0
		while true:
			var random_position = Vector2(randf_range(Storage.anthill_position.x - size.x / 2, Storage.anthill_position.x + size.x / 2), randf_range(Storage.anthill_position.y - size.y / 2, Storage.anthill_position.y + size.y / 2))
			var can_insert = true
			for pos in random_positions:
				if (random_position - pos).length() < min_spawn_distance: 
					can_insert = false
			if can_insert:
				random_positions.push_front(random_position)
				ResourcePositions.positions.push_front(random_position)
				break
			iterations += 1
			if iterations > max_iterations:
				random_positions.push_front(random_position)
				ResourcePositions.positions.push_front(random_position)
				print("Maximum amount of iterations was achieved while searching for avalible position for leafs")
				break
	for pos in random_positions:
		var instance : Leaves = object_scene.instantiate()
		instance.position = pos
		add_child(instance)
		
		ResourcePositions.resources.push_front(instance)
		
		# Создаем и добавляем кнопки
		var buttons_instance = button_scene.instantiate()
		
		# Устанавливаем позицию кнопок относительно позиции листьев
		buttons_instance.position = instance.position - Vector2(0, 80)
		
		add_child(buttons_instance)
#
		### Подписываемся на сигналы кнопок
		buttons_instance.get_node("ButtonPlus").connect("pressed", _on_ButtonPlus_pressed.bind(instance, buttons_instance))
		buttons_instance.get_node("ButtonMinus").connect("pressed", _on_ButtonMinus_pressed.bind(instance, buttons_instance))


func _on_ButtonPlus_pressed(instance, buttons_instance):
	if Storage.get_free_ants() <= 0:
		return
		
	_update_workers(instance, buttons_instance, instance.workers + 1)
	Storage.working_ants += 1
	print(Storage.working_ants)

func _on_ButtonMinus_pressed(instance, buttons_instance):
	if Storage.working_ants <= 0 || instance.workers <= 0:
		return
		
	_update_workers(instance, buttons_instance, instance.workers - 1)
	Storage.working_ants -= 1
	print(Storage.working_ants)

func _update_workers(instance, buttons_instance, workers_value):
	instance.workers = workers_value
	var workers_label = buttons_instance.get_node("WorkersLabel")
	workers_label.text = "[center]" + str(workers_value) + "[/center]"
