extends State

#Data
var target_position : Vector2
var launch : bool = false
var target_range : int = 5

#Refrences
@onready var timer : Timer = $Timer

func enter(_msg := {}):
	owner.emote.visible = true
	owner.label.text = "Chase"
	timer.start()

func physics_update(delta: float) -> void:
	seek_player()
	
	if launch:
		if owner.global_position.distance_to(target_position) <= target_range:
			owner.emote.visible = true
			if timer.is_stopped():
				timer.start()
			apply_friction(delta)
		else:
			accelerate_towards_point(target_position, delta)
	else:
		apply_friction(delta)
		
	owner.add_gravity(delta)

func seek_player():
	if owner.short_vision.can_shoot_player():
		state_machine.transition_to("Attack")
		return
	if not owner.long_vision.can_see_player():
		launch = false
		state_machine.transition_to("Idle")

func accelerate_towards_point(point, delta):
	#Moving to the start position
	var direction = owner.global_position.direction_to(point).normalized()
	owner.velocity = owner.velocity.move_toward(direction * owner.movement_data.max_speed, owner.movement_data.acceleration * delta)
	
	#Look where moving
	owner.animator.flip_h = owner.velocity.x > 0

func apply_friction(delta):
	owner.velocity = owner.velocity.move_toward(Vector2.ZERO, owner.movement_data.friction * delta)

func _on_timer_timeout():
	owner.emote.visible = false
	if owner.long_vision.player != null:
		target_position = owner.long_vision.target_in_range.global_position
		launch = true
