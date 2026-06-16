class_name InputComponent extends Node

var move_dir: Vector2 = Vector2.ZERO
signal jump_pressed
signal heal_pressed
signal hurt_pressed
signal move_input_changed(input_vector: Vector2)

func update() -> void:
	move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if Input.is_action_just_pressed("jump"):
		jump_pressed.emit()
	if Input.is_action_just_pressed("heal"): 
		heal_pressed.emit()
	if Input.is_action_just_pressed("hurt"):
		hurt_pressed.emit()
		


func _process(_delta: float) -> void:
	# Читаем движение по горизонтали и вертикали
	var horizontal := Input.get_axis("move_left", "move_right")
	var vertical := Input.get_axis("move_up", "move_down")
	var input_vector := Vector2(horizontal, vertical)
	
	# Нормализуем для диагонали
	if input_vector.length() > 1.0:
		input_vector = input_vector.normalized()
		
	move_input_changed.emit(input_vector)
	
	# Прыжок
	if Input.is_action_just_pressed("jump"):
		jump_pressed.emit()
	
