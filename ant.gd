extends CharacterBody2D

class_name Ant

@onready var animated_sprite = $AnimatedSprite2D
# Максимальная скорость движения
var max_speed = 500
# Минимальная скорость движения
var min_speed = 20

var target_position = Vector2.ZERO
var viewport_size = Vector2.ZERO
@export
var direction = Vector2.ZERO

func _process(delta):
	var speed = randf_range(min_speed, max_speed)
	velocity = direction * speed
	
	animated_sprite.play("walk")
	animated_sprite.rotation = direction.angle() + deg_to_rad(90)
	
	move_and_slide()
