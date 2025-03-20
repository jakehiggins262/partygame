class_name MyHitbox

extends Area2D

@export var damage := 10

func _init() -> void:
	collision_layer = 2 #sets collision layer of hitboxes to be value 2
	collision_mask = 0 #turns off collision masks
