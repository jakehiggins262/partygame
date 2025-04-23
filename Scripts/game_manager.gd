extends Node2D

# --- Configuration ---
@export var powerup_scenes: Array[PackedScene] = []
@export var num_powerups: int = 5
@export var map_width: float = 1920
@export var map_height: float = 1080
@export var respawn_interval: float = 10.0
@export var rounds_to_win: int = 10

# --- Game State ---
var players = []
var player_wins = {}  # Dictionary: player name -> win count
var respawn_points = {}

# --- Initialization ---
func _ready():
	_initialize_players()
	_initialize_respawn_points()
	_start_powerup_timer()
	randomize()

func _initialize_players():
	players = get_tree().get_nodes_in_group("Players")
	for player in players:
		player_wins[player.name] = 0
		player.player_died.connect(_on_player_died)
	print("Players found:", players)

func _initialize_respawn_points():
	for i in range(1, 9):
		var point = get_node_or_null("RespawnPoint" + str(i))
		if point:
			respawn_points[i] = point.global_position
		else:
			print("RespawnPoint" + str(i) + " not found.")

func _start_powerup_timer():
	var timer = Timer.new()
	timer.wait_time = respawn_interval
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

# --- Powerup Spawning ---
func _on_timer_timeout():
	if powerup_scenes.is_empty():
		print("No powerup scenes assigned.")
		return

	var random_scene = powerup_scenes[randi() % powerup_scenes.size()]
	spawn_powerup(random_scene)

func spawn_powerup(scene: PackedScene):
	if scene:
		var instance = scene.instantiate()
		instance.position = get_random_position()
		add_child(instance)

func get_random_position() -> Vector2:
	return Vector2(
		randf_range(100, map_width - 100),
		randf_range(100, map_height - 100)
	)

# --- Round and Game Logic ---
func _on_player_died(player_name):
	var alive_players = []
	for player in players:
		if not player.is_dead:
			alive_players.append(player)

	if alive_players.size() == 1:
		_end_round(alive_players[0])

func _end_round(winner):
	var name = winner.name
	player_wins[name] += 1
	print("%s wins the round!" % name)

	if player_wins[name] >= rounds_to_win:
		_end_game(name)
	else:
		_reset_round()

func _reset_round():
	# Reset all players
	for player in players:
		player.respawn()

	# Clear powerups
	for powerup in get_tree().get_nodes_in_group("tempPowerup"):
		powerup.queue_free()

	# Clear structures
	for structure in get_tree().get_nodes_in_group("Structures"):
		structure.queue_free()

func _end_game(winner_name):
	print("%s wins the game!" % winner_name)
	get_tree().change_scene_to_file("res://Levels/main_menu.tscn")
