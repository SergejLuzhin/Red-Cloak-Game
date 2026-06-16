class_name InputComponent extends Node

var move_dir: Vector2 = Vector2.ZERO
signal jump_pressed
signal heal_pressed
signal hurt_pressed

func update() -> void:
	move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if Input.is_action_just_pressed("jump"):
		jump_pressed.emit()
	if Input.is_action_just_pressed("heal"): 
		heal_pressed.emit()
	if Input.is_action_just_pressed("hurt"):
		hurt_pressed.emit()
	
