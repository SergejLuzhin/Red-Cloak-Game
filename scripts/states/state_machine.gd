class_name StateMachine extends Node

# --- LINKS ---
@export var initial_state: State
var current_state: State
var previous_state: State

# Links to Components:
var body: CharacterBody2D =  null
var input: InputComponent = null
var movement: MovementComponent = null
var animation: AnimationComponent = null

# List of existing (attached) states
var states: Dictionary = {}

# --- INITIALIZATION ---
func init(body: CharacterBody2D, input: InputComponent, movement: MovementComponent, animation: AnimationComponent) -> void:
	self.body = body
	self.input = input 
	self.movement = movement
	self.animation = animation
	
	# Register all child states
	for child: State in get_children():
		states[child.name.to_lower()] = child
		child.state_machine = self
		child.body = body
		child.input = input 
		child.movement = movement
		child.animation = animation
		
	# Start with initial state
	if initial_state:
		transition_to(initial_state.name.to_lower())
	else:
		print("Warning! " + body.name + " has no initial state attached to State Machine")
	
# --- STATES TRANSITION ---
func transition_to(new_state_name: String) -> void:
	var desired_state_name: String = new_state_name.to_lower()
	
	if not current_state:
		push_error("ERROR! No current state")
		return
	
	# Check if new state exists
	if not states.has(desired_state_name):
		push_error("ERROR! State for transition not found: " + desired_state_name)
		return
	
	# Check local state transition rules
	if not current_state.can_transition_to(desired_state_name):
		push_warning("State ", current_state.name, " forbids transition to ", desired_state_name)
		return
		
	# Check for additional conditions
	## ADD LATER (for example cant go DEAD if health > 0)
	
	# Make transition
	if current_state:
		previous_state = current_state
		current_state.exit()
		
	current_state = states.get(desired_state_name)
	current_state.enter()
	
# --- TRANSFER METHODS TO CURRENT STATE ---
func update(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func physics_update(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

### --- ADDITIONAL METHODS ---

# Get current state name
func get_current_state_name() -> String:
	if current_state:
		return current_state.name
	else:
		return ""
		
# Check if is in state
func is_in_state(state_name: String) -> bool:
	if not current_state: 
		return false
	else:
		return current_state.name.to_lower() == state_name.to_lower()
	
