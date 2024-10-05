extends Node2D

# Load the scene of the object you want to copy
var object_scene = preload("res://leaves.tscn")
var button_scene = preload("res://buttons.tscn")  # Загрузка сцены кнопок

# Number of objects to create
var number_of_objects = 5

func _ready():
	var viewport_size = get_window().size
	var spawn_instance = get_node("MainNode")
	
	for i in range(number_of_objects):
		var instance : Leaves = object_scene.instantiate()
		
		var random_position = Vector2(randf_range(0, viewport_size.x / 1.3), randf_range(0, viewport_size.y / 1.3))
		instance.position = random_position
		
		add_child(instance)
		
		# Создаем и добавляем кнопки
		var buttons_instance = button_scene.instantiate()
		
		# Устанавливаем позицию кнопок относительно позиции листьев
		buttons_instance.position = instance.position - Vector2(0, 60)
		
		add_child(buttons_instance)
		### Подписываемся на сигналы кнопок
		buttons_instance.get_node("ButtonPlus").connect("pressed", _on_ButtonPlus_pressed.bind(instance, buttons_instance))
		buttons_instance.get_node("ButtonMinus").connect("pressed", _on_ButtonMinus_pressed.bind(instance, buttons_instance))
	
func _on_ButtonPlus_pressed(instance, buttons_instance):
	_update_workers_label(instance, buttons_instance, instance.workers + 1)

func _on_ButtonMinus_pressed(instance, buttons_instance):
	_update_workers_label(instance, buttons_instance, instance.workers - 1)

func _update_workers_label(instance, buttons_instance, workers_value):
	if workers_value < 0:
		return
	instance.workers = workers_value
	var workers_label = buttons_instance.get_node("WorkersLabel")
	workers_label.text = "[center]" + str(workers_value) + "[/center]"
