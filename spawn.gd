extends Node2D

# Load the scene of the object you want to copy
var object_scene = preload("res://leaves.tscn")
var button_scene = preload("res://buttons.tscn")  # Загрузка сцены кнопок

# Number of objects to create
var number_of_objects = 5

var object_scenes = [preload("res://grassTile1.tscn"), preload("res://grassTile2.tscn"), preload("res://grassTile3.tscn")]

var rng = RandomNumberGenerator.new()

func _floor():
	# Number of objects to create
	var tilesX = 12
	var tilesY = 10
	var viewport_size = get_viewport().get_size();
	for i in range(tilesX):
		for j in range(tilesY):
			var r = int(rng.randf_range(0, 2))
			var instance = object_scenes[r].instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
			 # Randomly position the instance within the screen area
			var random_position = Vector2(i*((viewport_size.x+100)/tilesX), j*(viewport_size.y/tilesY))
			instance.position = random_position
  
			# Add the instance to the current scene
			add_child(instance)


func _ready():
	var viewport_size = get_window().size
	var spawn_instance = get_node("MainNode")
	
	_floor()
	
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
#
		### Подписываемся на сигналы кнопок
		buttons_instance.get_node("ButtonPlus").connect("pressed", _on_ButtonPlus_pressed.bind(instance))
		buttons_instance.get_node("ButtonMinus").connect("pressed", _on_ButtonMinus_pressed.bind(instance))
		
func _on_ButtonPlus_pressed(instance):
	instance.test += 1
	print(instance.test, " incremented by 1")

func _on_ButtonMinus_pressed(instance):
	instance.test -= 1
	print(instance.test, " decremented by 1")
