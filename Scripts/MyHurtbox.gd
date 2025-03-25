class_name MyHurtbox

extends Area2D


func _init() -> void:
	#these must compliment the hitbox
	#this allows this node to detect the MyHitbox Node
	collision_layer = 0 
	collision_mask = 2

func _ready() -> void:
	connect("area_entered", self._on_area_entered)
	

func _on_area_entered(hitbox: MyHitbox) -> void:
	if hitbox == null:
		return
	
	#owner of a node, is the top node of a scene it is in
	#owner property is used here because these hitboxes will be built as components of existing nodes 
	if owner.has_method("take_damage"):

		owner.take_damage(hitbox.damage)
