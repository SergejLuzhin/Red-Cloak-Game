class_name JumpComponent extends Node

# Links to character body and sprite
@export var body: CharacterBody2D 
@export var sprite: AnimatedSprite2D

# Jump parameters
@export var jump_force: float = 220.0 # Initial jump speed (pixels / second)
@export var gravity: float = 500.0 # Falling acceleration ( pixels / sec^2)
@export var max_jump_height: float = 100.0 # Max jump height in pixels

@export var jump_peak_threshold: float = 0.3 #minimal percentage from initial vertical velocity to be considered floating

# Inner local states
var is_jumping: bool = false
var vertical_velocity: float = 0.0
var ground_y: float = 0.0
var current_speed_vector: Vector2

# Signals
signal height_changed(current_height: float)
signal jump_up()
signal jump_peak()
signal jump_down()

# Initiate Jump method
func jump(speed_vector: Vector2):
	# Check if sprite is attached to JumpComponent
	if not sprite:
		push_warning("CANT JUMP! No Sprite attached to JumpComponent")
	
	# Check if already in jump
	if is_jumping:
		return
	
	# Save initial sprite height position on the ground	
	ground_y = sprite.offset.y 
	
	# Saving local states
	current_speed_vector = speed_vector
	is_jumping = true
	vertical_velocity = jump_force

# Handle physics every physical frame (delta ~ 0.0127 second at 60 fps)
func _physics_process(delta: float):
	if not is_jumping:
		return
	
	# Applying gravity
	vertical_velocity -= gravity * delta # 500 * 0.0167 = 8.35 lost height velocity pixels per frame (if gravity == 500)
	
	if vertical_velocity > 0 and vertical_velocity > jump_force * jump_peak_threshold:
		jump_up.emit() 
	elif abs(vertical_velocity) < jump_force * jump_peak_threshold:
		jump_peak.emit()
	elif vertical_velocity < 0:
		jump_down.emit()
	
	print(vertical_velocity)
	
	# Update sprite height offset
	if sprite:
		sprite.offset.y -= vertical_velocity * delta # Move sprite 
		height_changed.emit(sprite.offset.y) # Emit signal, send current height
		
		# Capping jump height to limit
		var current_height = abs(sprite.offset.y - ground_y) # abs to get rid of minus
		if current_height >= max_jump_height and vertical_velocity > 0:
			vertical_velocity = 0  # Stop acsending if reached the limit
		
		# Check if landed
		if sprite.offset.y >= ground_y: # '>' cause Y coordinate is inverted in Godot
			sprite.offset.y = ground_y # Position sprite strictly at ground level 
			height_changed.emit(sprite.offset.y)
			vertical_velocity = 0.0 # Reset vertical velocity after landing
			is_jumping = false

func is_on_ground() -> bool:
	return not is_jumping
