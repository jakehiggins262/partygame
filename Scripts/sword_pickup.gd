extends Node2D

@export var sword_scene: PackedScene
@export var respawn_time: float
@onready var sprite = $Sprite2D
@onready var collision_shape = $Area2D/CollisionShape2D

var is_available = true

func _ready():
	sprite.texture = preload("res://Art/Jake/swordpickupavail.png")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_available and body is CharacterBody2D and body.has_method("equip_weapon"):
		is_available = false
		
		# Instantiate the new weapon (sword)
		var new_weapon = sword_scene.instantiate()
		
		if body.current_weapon.name.begins_with("Sword"):  # Check if the weapon's name starts with "sword"
			# Boost the current weapon if it's a sword
			if body.current_weapon.sword_level == 2.0:
				#sword is at max level!
				print("Sword Level at Max!")
			else:
				body.current_weapon.boost_weapon()
				print("Weapon boosted! Attack Size Doubled!")
		else:
			# Equip the new weapon if the current weapon is not a sword
			body.equip_weapon(sword_scene)
			
			print("Player equipped a new weapon.")
		
		#temp fix for hitbox being enabled when weapon is picked up
		body.current_weapon.attack()
		
		# Update sprite and disable the collision shape for respawn
		sprite.texture = preload("res://Art/Jake/swordpickup.png")
		collision_shape.set_deferred("disabled", true)
		$Timer.start(respawn_time)

func _on_timer_timeout() -> void:
	is_available = true
	sprite.texture = preload("res://Art/Jake/swordpickupavail.png")
	collision_shape.set_deferred("disabled", false)
