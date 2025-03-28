extends Node2D
class_name Weapon

# Variables
@export var damage: int = 10
@export var attack_speed: float = 1.0
@export var range: float = 200.0
@export var owner_player: Node

# Signals
signal weapon_used

# Virtual function to be overridden
func attack():
	print("weapon attack called")
	weapon_used.emit()
