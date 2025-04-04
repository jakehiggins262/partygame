extends Node2D

@export var powerup_scenes: Array[PackedScene] = []

@export var num_powerups: int = 5  # Number of powerups to spawn
@export var map_width: float = 1920
@export var map_height: float = 1080
@export var respawn_interval: float = 10.0  # Time between powerup spawns

var respawn_points = {}

func _ready():
	randomize()
	
	# Find and store all respawn points by player ID
	for i in range(1, 9):
		var point = get_node_or_null("RespawnPoint" + str(i))
		if point:
			respawn_points[i] = point.global_position
		else:
			print("RespawnPoint" + str(i) + " not found.")
	
	# Start the timer for powerup spawns
	var timer = Timer.new()
	timer.wait_time = respawn_interval
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func _on_timer_timeout():
	if powerup_scenes.is_empty():
		print("No powerup scenes assigned.")
		return
	
	var random_index = randi() % powerup_scenes.size()
	var random_powerup_scene = powerup_scenes[random_index]
	
	spawn_powerup(random_powerup_scene)

func spawn_powerup(scene: PackedScene):
	if scene:
		var powerup_instance = scene.instantiate()
		powerup_instance.position = get_random_position()
		add_child(powerup_instance)

func get_random_position() -> Vector2:
	var random_x = randf_range(100, map_width - 100)
	var random_y = randf_range(100, map_height - 100)
	return Vector2(random_x, random_y)
