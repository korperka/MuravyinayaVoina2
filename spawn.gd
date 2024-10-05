extends Node2D

# Load the scene of the object you want to copy
var object_scene = preload("res://leaves.tscn")
var button_scene = preload("res://buttons.tscn")  # Загрузка сцены кнопок

# Number of objects to create
var number_of_objects = 10
var min_spawn_distance = 150
var max_iterations = 100

func _ready():
	var viewport_size = get_window().size
	var random_positions: Array[Vector2] = []
	
	for i in range(number_of_objects):
		var iterations = 0
		while true:
			var random_position = Vector2(randf_range(0, viewport_size.x), randf_range(0, viewport_size.y))
			var can_insert = true
			for pos in random_positions:
				if (random_position - pos).length() < min_spawn_distance: 
					can_insert = false
			if can_insert:
				random_positions.push_front(random_position)
				break
			iterations += 1
			if iterations > max_iterations:
				random_positions.push_front(random_position)
				print("Maximum amount of iterations was achieved while searching for avalible position for leafs")
				break
	for pos in random_positions:
		var instance : Leaves = object_scene.instantiate()
		instance.position = pos
		add_child(instance)
		
		# Создаем и добавляем кнопки
		var buttons_instance = button_scene.instantiate()
		
		# Устанавливаем позицию кнопок относительно позиции листьев
		buttons_instance.position = instance.position - Vector2(0, 60)
		
		add_child(buttons_instance)
#
		### Подписываемся на сигналы кнопок
		buttons_instance.get_node("ButtonPlus").connect("pressed", _on_ButtonPlus_pressed.bind(instance, ))
		buttons_instance.get_node("ButtonMinus").connect("pressed", _on_ButtonMinus_pressed.bind(instance))
		
func _on_ButtonPlus_pressed(instance):
	instance.test += 1
	print(instance.test, " incremented by 1")

func _on_ButtonMinus_pressed(instance):
	instance.test -= 1
	print(instance.test, " decremented by 1")
