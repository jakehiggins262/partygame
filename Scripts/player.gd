extends CharacterBody2D

@export var move_speed: float = 250  # @export allows us to edit this value in the inspector on the right
@export var starting_direction: Vector2 = Vector2(0, 1)
@export var player_id := 0
@export var block_scene: PackedScene
@export var weapon_scene: PackedScene

var current_weapon: Weapon
var bullet_path = preload("res://Scenes/bullet.tscn")
var last_direction: Vector2 = Vector2.ZERO
var gun = preload("res://Scenes/Weapons/gun.tscn")
var sword = preload("res://Scenes/Weapons/sword.tscn")
var is_dead = false
var can_place_block := false  # Boolean to check if the player can place a block
var block_instance: Node = null  # Instance of the block

signal player_died(player_id)

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
	add_to_group("Players")

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
	if Input.is_action_just_pressed("attack" + str(player_id)) and not is_dead:
		current_weapon.attack()
	## Player presses place structure button
	#if Input.is_action_just_pressed("place" + str(player_id)):
		#place()

func get_current_weapon(): 
	return Weapon

func equip_weapon(new_weapon_scene: PackedScene):
	weapon_scene = new_weapon_scene  # Store the new weapon scene
	call_deferred("_equip_weapon_deferred")  # Delay instantiation to avoid physics errors

func _equip_weapon_deferred():
	if weapon_scene == null:
		return  # Prevent errors if weapon_scene wasn't set

	var weapon_instance = weapon_scene.instantiate()
	$WeaponHolder.add_child(weapon_instance)
	current_weapon = weapon_instance


#func equip_weapon(weapon_scene: PackedScene):
	## Remove current weapon if it exists
	#if current_weapon:
		#current_weapon.queue_free()
#
	## Instantiate and attach the new weapon
	#var weapon_instance = weapon_scene.instantiate()
	#$WeaponHolder.add_child(weapon_instance)
	#current_weapon = weapon_instance
	

#func _on_my_hurtbox_area_entered(area: Area2D) -> void:
	#if area.is_in_group("bullet"):
		#print("collided with bullet")
		#queue_free()
	#if area.is_in_group("player"):
		#print("collided with player")

func take_damage(amount: int) -> void:
	if is_dead:
		return  # Ignore damage if already dead
	
	is_dead = true  # Mark player as dead
	emit_signal("player_died", player_id)
	print("Player", player_id, "took damage and will respawn.")
	move_speed = 250
	# Hide the player and disable movement
	hide()
	set_physics_process(false)
	
	# Disable collision to prevent interaction
	$CollisionShape2D.set_deferred("disabled", true)
	
	# Wait for a respawn delay
	if get_tree() == null:
		return  # Scene tree no longer exists

	await get_tree().create_timer(2.0).timeout

	
	#respawn()
	
func respawn():
	var game_manager = get_tree().current_scene.find_child("GameManager", true, false)

	if game_manager and player_id in game_manager.respawn_points:
		global_position = game_manager.respawn_points[player_id]
		#print("Player", player_id, "respawned at:", global_position)
	
	# Reset visibility, movement, and collision
	show()
	equip_weapon(sword)
	set_physics_process(true)
	$CollisionShape2D.set_deferred("disabled", false)
	
	is_dead = false  # Allow taking damage again

func change_color():
	if player_id >= 1 and player_id <= 8:
		$Sprite2D.modulate = player_colors[player_id - 1]
	else:
		print("Invalid player ID:", player_id)
		
func apply_speed_boost():
	move_speed = 500

func add_block_powerup():
	can_place_block = true  # Player can place blocks now

func _input(event):
	if event.is_action_pressed("place" + str(player_id)) and can_place_block:
		place_block()
		
func get_facing_direction() -> Vector2:
	# Assuming your player rotates based on movement, use the player's rotation
	return Vector2(cos(rotation), sin(rotation))  # Get direction as a unit vector

func get_place_position(direction: Vector2) -> Vector2:
	# Create a new RayCast2D node
	var ray = RayCast2D.new()
	ray.target_position = direction * 100  # Shorter distance (adjust as needed)
	ray.enabled = true  # Ensure the RayCast2D is active

	# Attach the ray to the player so it starts from the player's position
	add_child(ray)
	ray.force_raycast_update()

	# Get the collision point if there's a hit
	var collision_point = ray.get_collision_point() if ray.is_colliding() else position + direction * 50

	# Cleanup
	ray.queue_free()

	return collision_point

func place_block():
	# Get the direction the player is facing
	var direction = get_facing_direction()  # You can create your own method to get direction
	
	# Raycast to find a valid placement position
	var position = get_place_position(direction)
	
	# Instantiate and place the block
	block_instance = block_scene.instantiate()
	block_instance.position = position  # Set the position of the block
	get_tree().current_scene.add_child(block_instance)  # Add it to the scene
	
	can_place_block = false  # Disable further placement until a new block is picked up
