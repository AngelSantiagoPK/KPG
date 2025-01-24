extends Area2D

#Data
var player = null
var target_in_range = null

#Variables
#Variables
@onready var short_ray: RayCast2D = $ShortRay
@onready var collision: CollisionShape2D = $CollisionShape2D

func can_shoot_player():
	return player != null

func _physics_process(delta: float) -> void:
	if target_in_range != null:
		check_ray()

func check_ray() -> void:
	short_ray.look_at(target_in_range.global_position)
	short_ray.force_raycast_update()
	if short_ray.is_colliding():
		var collider = short_ray.get_collider()
		if collider.is_in_group("Player"):
			player = target_in_range

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target_in_range = body
		short_ray.enabled = true
	else:
		player = null


func _on_body_exited(body: Node2D) -> void:
	short_ray.enabled = false
	target_in_range = null
	player = null
