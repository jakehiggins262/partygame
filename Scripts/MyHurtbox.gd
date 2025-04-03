# Hurtbox Code
class_name MyHurtbox

extends Area2D

@export var bullet_scene: PackedScene = preload("res://Scenes/bullet.tscn")

func _init() -> void:
	# Set collision layers and masks
	collision_layer = 0
	collision_mask = 2

func _ready() -> void:
	# Connect the signal for collision detection
	connect("area_entered", self._on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area == null:
		return
	
	# Check if the area is a bullet by checking its group (assuming you added "Bullet" group to your bullets)
	if area.is_in_group("Bullet"):
		# If the bullet is the player's bullet, don't take damage
		var player = get_parent().get_parent()  # Assuming 'owner' is the player
		if area.get_parent().player_id == player.player_id:
			return  # Don't take damage from your own bullet

	# If the bullet is not the player's, take damage
	if owner.has_method("take_damage"):
		owner.take_damage(area.damage)
