extends CharacterBody2D

@export var move_speed: float = 100  # @export allows us to edit this value in the inspector on the right
@export var starting_direction: Vector2 = Vector2(0, 1)
@export var player_id := 1
var bullet_path = preload("res://Scenes/bullet.tscn")

# Variable to store the last direction
var last_direction: Vector2 = Vector2.ZERO

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
	if Input.is_action_just_pressed("ui_accept"):
		fire()
		
	move_and_slide()

func fire():
	var bullet=bullet_path.instantiate()
	bullet.dir=global_rotation
	bullet.pos=$Node2D.global_position
	bullet.rota=global_rotation
	bullet.scale = Vector2(1, 1)
	get_tree().current_scene.add_child(bullet)
