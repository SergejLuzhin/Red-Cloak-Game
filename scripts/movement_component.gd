class_name MovementComponent extends Node

@export var body: CharacterBody2D
@export var sprite: AnimatedSprite2D

@export var speed: float = 100.0
@export var acceleration: float = 10.0
@export var friction: float = 10.0

@export var jump_velocity: float = 12.0
@export var gravity_multiplier: float = 3.0

@onready var parent: CharacterBody2D = get_parent()

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
		parent.velocity = parent.velocity.lerp(target_velocity, acceleration * delta)
	else:
		parent.velocity = parent.velocity.lerp(Vector2.ZERO, friction * delta)
	
	# Сигнал о текущей скорости (для анимаций)
	speed_changed.emit(parent.velocity.length())

var direction: Vector2 = Vector2.ZERO
var wants_jump: bool = false

func tick(delta: float) -> void:
	if body == null:
		return
		
	# Top-Down Movement
	body.velocity.x = direction.x * speed
	body.velocity.y = direction.y * speed
	
	###
	### TO DO: make a jump func
	###
	
	# Flip the sprite
	if sprite: 
		if direction.x < 0:
			sprite.flip_h = true
		elif direction.x > 0:
			sprite.flip_h = false
			
	# Play animations
	if sprite:
		if direction.x == 0 and direction.y == 0:
			sprite.play("idle")
		else: 
			sprite.play("run")
		
	body.move_and_slide()
