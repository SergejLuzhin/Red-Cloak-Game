class_name State extends Node

# State Machine Link
var state_machine: StateMachine

# Links to Components (initialize in State Machine):
var body: CharacterBody2D =  null
var input: InputComponent = null
var movement: MovementComponent = null
var animation: AnimationComponent = null

###########################################
## Virtual States that child can override ##
###########################################

# Inicialization
func enter():
	pass
	
# Clean Up
func exit():
	pass
	
# Frame logic 
func update(delta: float):
	pass
	
# Movement
func physics_update(delta: float):
	pass

# SAFE TRANSITION
func transition_to(state_name: String) -> void:
	if state_machine:
		state_machine.transition_to(state_name)

# PROTECT FROM FORBIDDEN TRANSITIONS
func can_transition_to(state_name: String) -> bool:
	return true # By default all transitions are allowed
