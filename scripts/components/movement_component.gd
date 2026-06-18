class_name MovementComponent extends Node

@export var body: CharacterBody2D

@export var speed: float = 100.0
@export var acceleration: float = 15
@export var friction: float = 15

signal direction_changed(direction: Vector2)
signal speed_changed(current_speed: float)

var current_direction: Vector2 = Vector2.ZERO

func move(direction: Vector2, delta: float) -> void:
	
	  # Сохраняем направление для анимаций
	if direction.length() > 0:
		current_direction = direction.normalized()
		direction_changed.emit(current_direction)
	
	# Плавное ускорение/торможение
	if direction.length() > 0:
		var target_velocity = direction.normalized() * speed
		body.velocity = body.velocity.lerp(target_velocity, acceleration * delta)
	else:
		body.velocity = body.velocity.lerp(Vector2.ZERO, friction * delta)
	
	# Сигнал о текущей скорости (для анимаций)
	speed_changed.emit(body.velocity)
