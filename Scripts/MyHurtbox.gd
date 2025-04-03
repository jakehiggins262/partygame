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
	
	# Bullet collision checks
	if area.is_in_group("Bullet"):
		var bullet = area.get_parent()  # Assuming the bullet's parent has player_id and damage info
		
		# Check if bullet hit a player
		if get_parent().get_parent().is_in_group("players"):
			# Bullet hits a player
			print("Bullet hit a player!")
			
			var player = get_parent().get_parent()  # Assuming 'owner' is the hurtbox owner, typically the player
			
			if bullet.player_id == player.player_id:
				# Don't take damage from your own bullet
				print("Player's own bullet hit!")
				return  # Early return to prevent damage
				
			if owner.has_method("take_damage"):
				# Apply damage if the bullet belongs to another player
				print("Player takes damage!")
				owner.take_damage(area.damage)
		
		# Bullet hit a boundary (non-player collision)
		else:
			print("Bullet hit a boundary!")
			bullet.queue_free()  # Destroy the bullet

	if owner.has_method("take_damage"):
		owner.take_damage(area.damage)
