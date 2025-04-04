extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		print("player picked it up")
		body.add_block_powerup()
		queue_free()
