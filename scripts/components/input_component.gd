class_name InputComponent extends Node

signal jump_pressed
signal heal_pressed
signal hurt_pressed
signal move_input_changed(input_vector: Vector2)

var horizontal_movement: float
var vertical_movement: float
var input_vector: Vector2 = Vector2.ZERO


func _process(_delta: float) -> void:
	# Reading movement inputs
	horizontal_movement = Input.get_axis("move_left", "move_right")
	vertical_movement = Input.get_axis("move_up", "move_down")
	input_vector = Vector2(horizontal_movement, vertical_movement)
	
	# Normalize diagonal vector
	if input_vector.length() > 1.0:
		input_vector = input_vector.normalized()
		
	# Send final movement vector
	move_input_changed.emit(input_vector)
	
	# JUMP button pressed
	if Input.is_action_just_pressed("jump"):
		jump_pressed.emit()
		
	# HEAL button pressed
	if Input.is_action_just_pressed("heal"): 
		heal_pressed.emit()
		
	# HURT button pressed
	if Input.is_action_just_pressed("hurt"):
		hurt_pressed.emit()
		

	
