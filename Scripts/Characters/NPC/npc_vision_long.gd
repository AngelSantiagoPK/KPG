extends Area2D

#Data
var player = null
var target_in_range = null

#Variables
@onready var long_ray: RayCast2D = $LongRay
@onready var collision: CollisionShape2D = $CollisionShape2D

func can_see_player():
	return player != null

func _physics_process(delta: float) -> void:
	if owner.short_vision.player:
		player = null
		return
	
	if target_in_range != null:
		check_ray()

func check_ray() -> void:
	long_ray.look_at(target_in_range.global_position)
	long_ray.force_raycast_update()
	if long_ray.is_colliding():
		var collider = long_ray.get_collider()
		if collider.is_in_group("Player"):
			player = target_in_range

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target_in_range = body
		long_ray.enabled = true
	else:
		player = null


func _on_body_exited(body: Node2D) -> void:
	long_ray.enabled = false
	target_in_range = null
	player = null
