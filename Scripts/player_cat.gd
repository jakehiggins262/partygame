extends CharacterBody2D

@export var move_speed: float = 100  # @export allows us to edit this value in the inspector on the right
@export var starting_direction: Vector2 = Vector2(0, 1)
@export var player_id := 0
var bullet_path = preload("res://Scenes/bullet.tscn")

@onready var animation_tree = $AnimationTree
#animation player init
@onready var animation_player := $AnimationPlayer
@onready var state_machine = animation_tree.get("parameters/playback")

# Variable to store the last direction
var last_direction: Vector2 = Vector2.ZERO

func _ready():
	update_animation_parameters(starting_direction)

func _physics_process(_delta):
	# Get Input Directions
	var input_direction = Vector2(
		Input.get_action_strength("right" + str(player_id)) - Input.get_action_strength("left" + str(player_id)),
		Input.get_action_strength("down" + str(player_id)) - Input.get_action_strength("up" + str(player_id))
	)
	
	# Update the last direction if there's input
	if input_direction.length() > 0:
		last_direction = input_direction.normalized()

	update_animation_parameters(input_direction)
	
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
	pick_new_state()

func update_animation_parameters(move_input: Vector2):
	# Don't change animation parameters if there is no move input
	if move_input != Vector2.ZERO:
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)

func pick_new_state():
	# Transition between walk and idle states based on velocity
	if velocity != Vector2.ZERO:
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")

func fire():
	var bullet=bullet_path.instantiate()
	bullet.dir=global_rotation
	bullet.pos=$Node2D.global_position
	bullet.rota=global_rotation
	bullet.scale = Vector2(1, 1)
	get_tree().current_scene.add_child(bullet)
	
	
func take_damage(amount: int) -> void:
	animation_player.play("hit")
	print("Damage: ", amount)
