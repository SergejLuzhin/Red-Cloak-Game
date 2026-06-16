class_name Player extends CharacterBody2D

@onready var input_component: InputComponent = %InputComponent
@onready var movement_component: MovementComponent = %MovementComponent
@onready var health_component: HealthComponent = %HealthComponent

func _ready() -> void:
	if input_component: 
		input_component.move_input_changed.connect(_on_move_input_changed)
		input_component.jump_pressed.connect(_on_jump_pressed)
		input_component.heal_pressed.connect(_on_heal_pressed)
		input_component.hurt_pressed.connect(_on_hurt_pressed)
	if health_component:
		health_component.has_died.connect(_on_has_died)
		
# --- Обработчики сигналов (Call Down) ---

func _on_move_input_changed(input_vector: Vector2):
	# Передаём управление движением в MovementComponent
	movement_component.move(input_vector, get_process_delta_time())


func _physics_process(delta: float) -> void:
	move_and_slide()
	
	# Read controls
	#input_component.update()
	
	# Read Movement Component
	#movement_component.direction = input_component.move_dir
	#movement_component.tick(delta)
			
func _on_jump_pressed() -> void:
	pass
	
func _on_heal_pressed() -> void:
	health_component.heal(10.0)

func _on_hurt_pressed() -> void: 
	health_component.take_damage(15.0)
			
func _on_has_died() -> void: 
	print("Player died!")
	
