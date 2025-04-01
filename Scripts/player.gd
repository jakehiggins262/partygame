extends CharacterBody2D

# Public variables
@export var move_speed: float = 250  # @export allows us to edit this value in the inspector on the right
@export var starting_direction: Vector2 = Vector2(0, 1)
@export var player_id := 0

# Private variables
var current_weapon: Weapon
var bullet_path = preload("res://Scenes/bullet.tscn")
var last_direction: Vector2 = Vector2.ZERO
var gun = preload("res://Scenes/Weapons/gun.tscn")
var sword = preload("res://Scenes/Weapons/sword.tscn")
# Predefined player colors (Adjust as needed)
var player_colors = [
	Color(0.0, 0.5, 1.0),  # Blue for Player 1
	Color(1.0, 0.1, 0.1),  # Red for Player 2
	Color(0.1, 1.0, 0.1),  # Green for Player 3
	Color(1.0, 1.0, 0.1),  # Yellow for Player 4
	Color(1.0, 0.1, 1.0),  # Purple for Player 5
	Color(1.0, 0.5, 0.0),  # Orange for Player 6
	Color(0.1, 1.0, 1.0),  # Cyan for Player 7
	Color(0.5, 0.1, 0.5)   # Dark Purple for Player 8
]

func _ready():
	equip_weapon(sword)
	change_color()


#animation player init
#@onready var animation_player := $AnimationPlayer

func _physics_process(_delta):
	# Get Input Directions
	var input_direction = Vector2(
		Input.get_action_strength("right" + str(player_id)) - Input.get_action_strength("left" + str(player_id)),
		Input.get_action_strength("down" + str(player_id)) - Input.get_action_strength("up" + str(player_id))
	)
	
	# Update the last direction if there's input
	if input_direction.length() > 0:
		last_direction = input_direction.normalized()

	# Update velocity
	velocity = input_direction * move_speed
	
	# Rotate to the last valid direction if idle
	if velocity == Vector2.ZERO and last_direction != Vector2.ZERO:
		rotation = last_direction.angle()
	else:
		rotation = velocity.angle()
		
	move_and_slide()
	
func _process(_delta):
	# Player presses attack button
	if Input.is_action_just_pressed("attack" + str(player_id)):
		current_weapon.attack()
	## Player presses place structure button
	#if Input.is_action_just_pressed("place" + str(player_id)):
		#place()

func equip_weapon(weapon_scene: PackedScene):
	# Remove current weapon if it exists
	if current_weapon:
		current_weapon.queue_free()

	# Instantiate and attach the new weapon
	var weapon_instance = weapon_scene.instantiate()
	$WeaponHolder.add_child(weapon_instance)
	current_weapon = weapon_instance

#func _on_my_hurtbox_area_entered(area: Area2D) -> void:
	#if area.is_in_group("bullet"):
		#print("collided with bullet")
		#queue_free()
	#if area.is_in_group("player"):
		#print("collided with player")

func take_damage(amount: int) -> void:
	print("Player", player_id, "took damage and will respawn.")
	
	# Hide the player and disable movement
	hide()
	set_physics_process(false)
	
	# Disable collision to prevent interaction
	$CollisionShape2D.set_deferred("disabled", true)
	
	# Wait for a respawn delay
	await get_tree().create_timer(2.0).timeout
	
	respawn()

func respawn():
	var game_manager = get_tree().root.get_node("Game_Level/GameManager")
	if game_manager and player_id in game_manager.respawn_points:
		global_position = game_manager.respawn_points[player_id]
		print("Player", player_id, "respawned at:", global_position)
	
	# Reset visibility, movement, and collision
	show()
	equip_weapon(sword)
	set_physics_process(true)
	$CollisionShape2D.set_deferred("disabled", false)

func change_color():
	if player_id >= 1 and player_id <= 8:
		$Sprite2D.modulate = player_colors[player_id - 1]
	else:
		print("Invalid player ID:", player_id)
		
func apply_speed_boost():
	move_speed = 500
