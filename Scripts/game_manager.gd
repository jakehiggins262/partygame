extends Node2D

@export var powerup_scenes: Array[PackedScene] = []

@export var num_powerups: int = 5  # Number of powerups to spawn
@export var map_width: float = 1920
@export var map_height: float = 1080
@export var respawn_interval: float = 10.0  # Time between powerup spawns

var players = [] # List of player nodes
var player_wins = {} # Dictionary: player name/id -> round wins
var rounds_to_win = 10

var respawn_points = {}

func _ready():
	players = get_tree().get_nodes_in_group("Players")
	print(players)
	for player in players:
		player_wins[player.name] = 0
		player.player_died.connect(_on_player_died)
		
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

func _on_player_died(player_name):
	#for p in players:
		#if p.player_id == player_name:
			#p.queue_free() # Or set an is_alive flag to false
			#break
			
	var alive_players = []
	for p in players:
		if not(p.is_dead):
			alive_players.append(p)
	
	if alive_players.size() == 1:
		_end_round(alive_players[0])

func _end_round(winner):
	var winner_name = winner.name
	player_wins[winner_name] += 1
	print("%s wins the round!" % winner_name)
	
	if player_wins[winner_name] >= rounds_to_win:
		_end_game(winner_name)
	else:
		_reset_round()

func _reset_round():
	# Reload the scene or reset player positions/hp
	for player in players:
		player.respawn()
		
	# Remove all powerups
	for powerup in get_tree().get_nodes_in_group("tempPowerup"):
		powerup.queue_free()

	# Remove all structures
	for structure in get_tree().get_nodes_in_group("Structures"):
		structure.queue_free()

func _end_game(winner_name):
	print("%s wins the game!" % winner_name)
	get_tree().change_scene_to_file("res://Levels/main_menu.tscn")
	# Optionally show a game over screen and return to main menu
