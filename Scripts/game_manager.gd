extends Node2D

# Dictionary to store respawn points by player ID
var respawn_points = {}

func _ready():
	# Find and store all respawn points based on their name
	for i in range(1, 9):
		var point = get_node_or_null("RespawnPoint" + str(i))
		if point:
			respawn_points[i] = point.global_position
		else:
			print("RespawnPoint" + str(i) + " not found.")
