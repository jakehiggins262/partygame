extends CharacterBody2D

# --- Exports ---
@export var move_speed: float = 250
@export var starting_direction: Vector2 = Vector2(0, 1)
@export var player_id := 0
@export var block_scene: PackedScene
@export var weapon_scene: PackedScene

# --- Signals ---
signal player_died(player_id)

# --- Variables ---
var current_weapon: Weapon
var is_dead = false
var can_place_block := false
var block_instance: Node = null
var last_direction: Vector2 = Vector2.ZERO

# --- Preloads ---
var gun = preload("res://Scenes/Weapons/gun.tscn")
var sword = preload("res://Scenes/Weapons/sword.tscn")
var bullet_path = preload("res://Scenes/bullet.tscn")

# --- Player Colors ---
var player_colors = [
	Color(0.0, 0.5, 1.0),  Color(1.0, 0.1, 0.1), Color(0.1, 1.0, 0.1),
	Color(1.0, 1.0, 0.1), Color(1.0, 0.1, 1.0), Color(1.0, 0.5, 0.0),
	Color(0.1, 1.0, 1.0), Color(0.5, 0.1, 0.5)
]

# --- Built-in Functions ---
func _ready():
	equip_weapon(sword)
	change_color()
	add_to_group("Players")

func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right" + str(player_id)) - Input.get_action_strength("left" + str(player_id)),
		Input.get_action_strength("down" + str(player_id)) - Input.get_action_strength("up" + str(player_id))
	)

	if input_direction.length() > 0:
		last_direction = input_direction.normalized()

	velocity = input_direction * move_speed
	rotation = (last_direction if velocity == Vector2.ZERO else velocity).angle()
	move_and_slide()

func _process(_delta):
	if Input.is_action_just_pressed("attack" + str(player_id)) and not is_dead:
		current_weapon.attack()

func _input(event):
	if event.is_action_pressed("place" + str(player_id)) and can_place_block:
		place_block()

# --- Player Logic ---
func take_damage(amount: int) -> void:
	if is_dead: return

	is_dead = true
	emit_signal("player_died", player_id)
	print("Player", player_id, "took damage and will respawn.")
	move_speed = 250
	hide()
	set_physics_process(false)
	$CollisionShape2D.set_deferred("disabled", true)

	if get_tree():
		await get_tree().create_timer(2.0).timeout

func respawn():
	var game_manager = get_tree().current_scene.find_child("GameManager", true, false)

	if game_manager and player_id in game_manager.respawn_points:
		global_position = game_manager.respawn_points[player_id]

	show()
	equip_weapon(sword)
	set_physics_process(true)
	$CollisionShape2D.set_deferred("disabled", false)
	is_dead = false

func change_color():
	if player_id >= 1 and player_id <= 8:
		$Sprite2D.modulate = player_colors[player_id - 1]
	else:
		print("Invalid player ID:", player_id)

# --- Weapon Methods ---
func get_current_weapon():
	return current_weapon

func equip_weapon(new_weapon_scene: PackedScene):
	weapon_scene = new_weapon_scene
	call_deferred("_equip_weapon_deferred")

func _equip_weapon_deferred():
	if weapon_scene == null: return
	if current_weapon:
		current_weapon.queue_free()
		current_weapon = null

	var weapon_instance = weapon_scene.instantiate()
	$WeaponHolder.add_child(weapon_instance)
	current_weapon = weapon_instance

# --- Powerups ---
func apply_speed_boost():
	move_speed = 500

func add_block_powerup():
	can_place_block = true

# --- Block Placement ---
func get_facing_direction() -> Vector2:
	return Vector2(cos(rotation), sin(rotation))

func get_place_position(direction: Vector2) -> Vector2:
	var ray = RayCast2D.new()
	ray.target_position = direction * 100
	ray.enabled = true
	add_child(ray)
	ray.force_raycast_update()

	var collision_point = ray.get_collision_point() if ray.is_colliding() else position + direction * 50
	ray.queue_free()
	return collision_point

func place_block():
	var direction = get_facing_direction()
	var position = get_place_position(direction)

	block_instance = block_scene.instantiate()
	block_instance.position = position
	get_tree().current_scene.add_child(block_instance)
	can_place_block = false
