extends Area2D

@export var gun_scene: PackedScene

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body is CharacterBody2D and body.has_method("equip_weapon"):
		body.equip_weapon(gun_scene)
		queue_free()
