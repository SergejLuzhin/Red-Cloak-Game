class_name HealthComponent extends Node

signal health_changed(current: float, max: float)
signal has_died

@export var max_health: float = 100.0
@export var min_health: float = 0.0
var current_health: float = 0.0

func _ready() -> void:
	current_health = max_health
	_emit()
	
func take_damage(damage_amount: float) -> void:
	current_health = clamp(current_health - damage_amount, min_health, max_health)
	_emit()
	if current_health == 0.0:
		has_died.emit()
		
		
func heal(healing_amount: float) -> void:
	current_health = clamp(current_health + healing_amount, min_health, max_health)
	_emit()
	
func _emit() -> void:
	health_changed.emit(current_health, max_health)
	print("HP: %d / %d" % [current_health, max_health])
