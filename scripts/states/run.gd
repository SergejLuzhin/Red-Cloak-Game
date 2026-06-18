class_name Run extends State

@export var speed: float = 90.0
@export var acceleration: float = 20.0
@export var friction: float = 15.0

signal direction_changed(direction: Vector2)
signal speed_changed(current_speed: float)

var current_direction: Vector2 = Vector2.ZERO

func enter() -> void:
	animation.play("run")

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
	speed_changed.emit(body.velocity.length())
