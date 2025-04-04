extends Area2D

@export var speed_boost: float = 400.0  # How much to increase the player's speed
@export var boost_duration: float = 5.0  # How long the boost lasts
@export var respawn_time: float = 1.0  # Time before the powerup respawns

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		#print("Player", body.player_id, "picked up speed powerup!")
		body.apply_speed_boost()
		hide()
		collision_shape.set_deferred("disabled", true)
		await get_tree().create_timer(respawn_time).timeout
		respawn()

func respawn():
	print("Speed powerup respawned.")
	position = get_random_position()
	show()
	collision_shape.set_deferred("disabled", false)

func get_random_position() -> Vector2:
	# Assuming the map is 1920x1080. Adjust accordingly.
	var random_x = randf_range(100, 1820)
	var random_y = randf_range(100, 980)
	return Vector2(random_x, random_y)
