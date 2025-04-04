# block_powerup.gd
extends Powerup

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		on_collected(body)

func on_collected(body: Node2D) -> void:
	body.add_block_powerup()
	queue_free()
