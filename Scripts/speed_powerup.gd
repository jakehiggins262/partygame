# speed_powerup.gd
extends Powerup

@export var speed_boost: float = 400.0
@export var boost_duration: float = 5.0
@onready var sprite = $Sprite2D

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		on_collected(body)

func on_collected(body: Node2D) -> void:
	body.apply_speed_boost()
	hide()
	collision_shape.set_deferred("disabled", true)
	await get_tree().create_timer(respawn_time).timeout
	respawn()
