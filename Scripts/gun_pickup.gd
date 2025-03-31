extends Node2D

@export var gun_scene: PackedScene
@export var respawn_time: float
@onready var sprite = $Sprite2D
@onready var collision_shape = $Area2D/CollisionShape2D

var is_available = true

func _ready():
	sprite.texture = preload("res://Art/Jake/gunpickupavail.png")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_available and body is CharacterBody2D and body.has_method("equip_weapon"):
		is_available = false
		body.equip_weapon(gun_scene)
		sprite.texture = preload("res://Art/Jake/gunpickup.png")
		collision_shape.set_deferred("disabled", true)
		$Timer.start(respawn_time) # 2-second respawn timer

func _on_timer_timeout() -> void:
	is_available = true
	sprite.texture = preload("res://Art/Jake/gunpickupavail.png")
	collision_shape.set_deferred("disabled", false)
