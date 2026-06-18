class_name AnimationComponent extends Node

@export var sprite: AnimatedSprite2D
@export var shadow: Sprite2D

@export var shadow_scale_intensity: float = 0.01
@export var min_shadow_scale: float = 0.3

const IDLE_ANIMATION_SPEED_THRESHOLD: float = 10.0

signal has_changed_aninmation(current_animation: String)

func play(animation: String) -> void:
	sprite.play(animation)

func flip_sprite_horizontally() -> void:
	if sprite: 
		sprite.flip_h = true
	
func flip_sprite_to_movement_direction(direction: Vector2) -> void:
	if direction.x < 0:
		sprite.flip_h = true
	if direction.x > 0:
		sprite.flip_h = false
		
func play_animation_according_to_speed(speed: float) -> void: 
	if speed < IDLE_ANIMATION_SPEED_THRESHOLD:
		sprite.play("idle")
	elif speed >= IDLE_ANIMATION_SPEED_THRESHOLD:
		sprite.play("run")
		
func play_animation_according_to_input(input_vector: Vector2) -> void:
	if input_vector != Vector2.ZERO: 
		sprite.play("run")
	else:
		sprite.play("idle")

func resize_shadow_according_to_height(current_height: float) -> void:
	current_height = abs(current_height)
	var shadow_scale: float = 1.0 - (current_height * shadow_scale_intensity)
	shadow_scale = clamp(shadow_scale, min_shadow_scale, 1.0)
	shadow.scale = Vector2(shadow_scale, shadow_scale)
