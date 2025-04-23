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
		
		# Instantiate the new weapon (gun)
		var new_weapon = gun_scene.instantiate()
		
		# Check if the player's current weapon's name starts with "gun"
		if body.current_weapon.name.begins_with("gun"):  # Check if the weapon's name starts with "gun"
			# Boost the current weapon if it's a gun
			body.current_weapon.boost_weapon()
			print("Weapon boosted! Fire rate and bullet speed doubled.")
		else:
			# Equip the new weapon if the current weapon is not a gun
			body.equip_weapon(gun_scene)
			print("Player equipped a new weapon.")
		
		# Update sprite and disable the collision shape for respawn
		sprite.texture = preload("res://Art/Jake/gunpickup.png")
		collision_shape.set_deferred("disabled", true)
		$Timer.start(respawn_time)


func _on_timer_timeout() -> void:
	is_available = true
	sprite.texture = preload("res://Art/Jake/gunpickupavail.png")
	collision_shape.set_deferred("disabled", false)
