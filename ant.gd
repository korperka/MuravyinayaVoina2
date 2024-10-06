extends CharacterBody2D

class_name Ant

@onready var animated_sprite = $AnimatedSprite2D
var max_speed = 500
var min_speed = 20

var target_position = Vector2.ZERO
var initial_position = Vector2.ZERO
var is_moving = false
var return_after_target = false

var intermediate_points = []
var max_offset_distance = 50  # Максимальное отклонение от прямого пути

func _ready():
	initial_position = position

func _process(delta):
	if is_moving:
		move_to_target_logic(delta)

func move_to_target_logic(delta):
	# Проверка наличия промежуточных точек
	if intermediate_points.size() > 0:
		target_position = intermediate_points[0]  # Берём первую точку

	# Если мы приблизились к текущей цели (промежуточной точке или конечной цели)
	var distance_to_target = position.distance_to(target_position)
	if distance_to_target > 5:
		var direction = (target_position - position).normalized()
		var speed = randf_range(min_speed, max_speed)
		velocity = direction * speed
		
		animated_sprite.play("walk")
		animated_sprite.rotation = direction.angle() + deg_to_rad(90)
		
		move_and_slide()
	else:
		# Если достигли промежуточной точки, убираем её из списка
		if intermediate_points.size() > 0:
			intermediate_points.pop_front()

		# Если это была последняя точка, проверяем, нужно ли вернуться на исходную позицию
		if intermediate_points.size() == 0:
			if return_after_target:
				# Если цель — муравейник, удаляем муравья
				if target_position == initial_position:
					queue_free()  # Удалить муравья из сцены
				else:
					# Возвращаемся к исходной позиции
					target_position = initial_position
					generate_intermediate_points(position, target_position)  # Генерируем точки для возвращения
					return_after_target = false
			else:
				# Останавливаемся, если достигли цели
				is_moving = false

# Функция для начала движения к цели
func move_to_target(target: Vector2):
	target_position = target
	generate_intermediate_points(position, target_position)
	is_moving = true

# Функция для движения к цели и затем возвращения на исходную позицию
func move_to_target_return(target: Vector2):
	target_position = target
	return_after_target = true
	generate_intermediate_points(position, target_position)
	is_moving = true

# Генерация случайных промежуточных точек для движения по кривой
func generate_intermediate_points(start_pos: Vector2, end_pos: Vector2):
	intermediate_points.clear()

	# Находим расстояние и направление к цели
	var direction = (end_pos - start_pos).normalized()
	var distance = start_pos.distance_to(end_pos)

	# Генерируем промежуточные точки
	var num_points = int(distance / 100)  # Примерное количество точек, зависит от расстояния
	for i in range(num_points):
		# Располагаем промежуточную точку вдоль пути с добавлением случайного отклонения
		var interpolation_factor = float(i + 1) / float(num_points + 1)
		var point_on_path = start_pos.lerp(end_pos, interpolation_factor)  # Заменено на lerp()
		var offset = Vector2(randf_range(-max_offset_distance, max_offset_distance), randf_range(-max_offset_distance, max_offset_distance))
		intermediate_points.append(point_on_path + offset)

	# Добавляем конечную точку в список
	intermediate_points.append(end_pos)
