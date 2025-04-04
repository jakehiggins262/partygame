extends Weapon

@export var bullet_scene: PackedScene = preload("res://Scenes/bullet.tscn")
@export var fire_rate: float = 0.3
@export var bullet_speed: float = 500.0

var can_fire: bool = true

func attack():
	if can_fire:
		fire()
		can_fire = false
		$FireRateTimer.start(fire_rate)

func fire():
	# Access the player_id from the parent player node
	var player_id = get_parent().get_parent().player_id  # Get player_id from the player node (assumes Gun is a child of the player)

	# Instantiate the bullet scene (create an instance of the bullet)
	var bullet = bullet_scene.instantiate()

	# Set the properties on the bullet
	bullet.dir = global_rotation
	bullet.pos = $BulletSpawn.global_position
	bullet.rota = global_rotation
	bullet.speed = bullet_speed  # Pass bullet speed from the gun
	bullet.scale = Vector2(2, 2)
	bullet.player_id = player_id  # Set the player's ID on the bullet

	# Add the bullet to the scene
	get_tree().current_scene.call_deferred("add_child", bullet)


func _on_fire_rate_timer_timeout() -> void:
	can_fire = true

func boost_weapon():
	if fire_rate > .2 and bullet_speed <= 1001:
		fire_rate /= 2.0
		bullet_speed *= 2.0
		#print("Boost applied: Fire rate and bullet speed doubled!")
