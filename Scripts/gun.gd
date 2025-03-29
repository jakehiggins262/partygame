extends Weapon

@export var bullet_scene: PackedScene = preload("res://Scenes/bullet.tscn")
@export var fire_rate: float = 0.3
@export var bullet_speed: float = 500.0

var can_fire: bool = true

func attack():
	fire()

func fire():
	# Instantiate the bullet scene (create an instance of the bullet)
	var bullet = bullet_scene.instantiate()  # Instantiate the bullet
	
	# Set the properties on the bullet
	bullet.dir = global_rotation
	bullet.pos = $BulletSpawn.global_position  # Bullet spawn position
	bullet.rota = global_rotation  # Bullet's rotation (same as player's rotation)
	bullet.scale = Vector2(2, 2)  # Adjust scale if needed

	# Add the bullet to the scene
	get_tree().current_scene.add_child(bullet)
