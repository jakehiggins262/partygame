# Bullet code
extends CharacterBody2D

var pos: Vector2
var rota: float
var dir: float
var speed: float = 2000  # Default if not set by gun
var player_id: int  # Add this variable to store the player's ID

# Define the map boundaries (adjust these values as needed)
var left_boundary: float = 0
var right_boundary: float = 1920
var top_boundary: float = 0
var bottom_boundary: float = 1080

func _ready():
	global_position = pos
	global_rotation = rota
	add_to_group("Bullet")

func _physics_process(_delta):
	velocity = Vector2(speed, 0).rotated(dir)
	move_and_slide()

	# Check if the bullet is outside the defined boundaries
	if global_position.x < left_boundary or global_position.x > right_boundary or global_position.y < top_boundary or global_position.y > bottom_boundary:
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()


func _on_area_2d_area_entered(area):
	if area is CharacterBody2D:
		if area.has_method("take_damage"):
			area.take_damage(1)
			print("Player hit!")
			queue_free()
