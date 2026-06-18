class_name Player extends CharacterBody2D

@onready var input_component: InputComponent = %InputComponent
@onready var movement_component: MovementComponent = %MovementComponent
@onready var health_component: HealthComponent = %HealthComponent
@onready var animation_component: AnimationComponent = %AnimationComponent
@onready var jump_component: JumpComponent = %JumpComponent

var current_speed_vector: Vector2
var current_height: float = 0.0

func _ready() -> void:
	if input_component: 
		input_component.move_input_changed.connect(_on_move_input_changed)
		input_component.jump_pressed.connect(_on_jump_pressed)
		input_component.heal_pressed.connect(_on_heal_pressed)
		input_component.hurt_pressed.connect(_on_hurt_pressed)
	if movement_component:
		movement_component.direction_changed.connect(_on_direction_changed)
		movement_component.speed_changed.connect(_on_speed_changed)
	if jump_component:
		jump_component.height_changed.connect(_on_height_changed)
		jump_component.jump_up.connect(_on_jump_up)
		jump_component.jump_peak.connect(_on_jump_peak)
		jump_component.jump_down.connect(_on_jump_down)
	
	if health_component:
		health_component.has_died.connect(_on_has_died)
	
## --- PHYSICAL FRAMES UPDATE --- ##
		
func _physics_process(delta: float) -> void:
	move_and_slide()
		
## --- INPUT SIGNALS --- ##

func _on_move_input_changed(input_vector: Vector2):
	movement_component.move(input_vector, get_process_delta_time())
	if current_height == 0:
		animation_component.play_animation_according_to_input(input_vector)
	
func _on_jump_pressed() -> void:
	jump_component.jump(current_speed_vector)
	
func _on_heal_pressed() -> void:
	health_component.heal(10.0)

func _on_hurt_pressed() -> void: 
	health_component.take_damage(15.0)
	
## --- MOVEMENT SIGNALS --- ##

func _on_direction_changed(direction: Vector2) -> void:
	animation_component.flip_sprite_to_movement_direction(direction)
	
func _on_speed_changed(current_speed: Vector2) -> void:
	current_speed_vector = current_speed
	
## --- JUMP SIGNALS --- ##

func _on_height_changed(height: float) -> void:
	current_height = height
	animation_component.resize_shadow_according_to_height(current_height)
	
func _on_jump_up() -> void:
	animation_component.play("jump_up")

func _on_jump_peak() -> void:
	animation_component.play("jump_peak")
	
func _on_jump_down() -> void:
	animation_component.play("jump_down")
	
	
## --- HEALTH SIGNALS --- ##

func _on_has_died() -> void: 
	print("Player died!")

	
	
