extends CharacterBody2D

# Public variables
@export var move_speed: float = 100  # @export allows us to edit this value in the inspector on the right
@export var starting_direction: Vector2 = Vector2(0, 1)
@export var player_id := 0

# Private variables
var current_weapon: Weapon
var bullet_path = preload("res://Scenes/bullet.tscn")
var last_direction: Vector2 = Vector2.ZERO
var gun = preload("res://Scenes/Weapons/gun.tscn")

func _ready():
	var sword = preload("res://Scenes/Weapons/sword.tscn")
	equip_weapon(sword)

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
	queue_free() # Destroy the player
