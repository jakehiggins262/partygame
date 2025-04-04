# powerup.gd
extends Area2D
class_name Powerup

@export var respawn_time: float = 1.0
@export var map_width: float = 1920
@export var map_height: float = 1080

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func on_collected(body: Node2D) -> void:
	pass # Must be implemented by child

func respawn():
	position = get_random_position()
	show()
	collision_shape.set_deferred("disabled", false)

func get_random_position() -> Vector2:
	var random_x = randf_range(100, map_width - 100)
	var random_y = randf_range(100, map_height - 100)
	return Vector2(random_x, random_y)
