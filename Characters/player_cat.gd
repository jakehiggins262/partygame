extends CharacterBody2D

@export var move_speed: float = 100  #@export allows us to edit this value in the inspector on the right
@export var starting_direction: Vector2 = Vector2(0, 1)


#parameters/Idle/blend_position
#when script starts we get access to this node that is in our scene
#this will look at our scene, find the object named AnimationTree, store in variable
@onready var animation_tree = $AnimationTree

#get the playback componenet from animation tree (AnimationNodeStateMachinePlayback)
@onready var state_machine = animation_tree.get("parameters/playback")

func _ready():
	update_animation_parameters(starting_direction)


func _physics_process(_delta):
	#Get Input Directions
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	update_animation_parameters(input_direction)
	#Update velocity
	velocity = input_direction * move_speed
	#Move and Slide function uses velocity or character body to move character on map
	move_and_slide()
	pick_new_state()
	
	
func update_animation_parameters(move_input: Vector2):
	
	#Don't change animation aparameters if there is no move input
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)
		
func pick_new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
