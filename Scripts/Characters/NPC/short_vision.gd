extends Area2D

#Data
var player = null

#Variables
#Variables
@onready var short_ray: RayCast2D = $ShortRay
@onready var collision: CollisionShape2D = $CollisionShape2D

func can_shoot_player():
	return player != null

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = null
