extends State

#Data
var wander_range : int = 64
var wander_target_range : int = 4

#Refrences
@onready var timer : Timer = $Timer

func enter(_msg := {}):
	owner.label.text = "Wander"
	update_target_position()

func physics_update(delta: float) -> void:
	seek_player()
	
	if owner.global_position.distance_to(owner.target_position) <= wander_target_range:
		apply_friction(delta)
		if timer.is_stopped():
			start_timer()
	else:
		accelerate_towards_point(owner.target_position, delta)
		start_timer()
	
	owner.add_gravity(delta)

func apply_friction(delta):
	owner.velocity = owner.velocity.move_toward(Vector2.ZERO, owner.movement_data.friction * delta)

func update_target_position(): #Picks a random position to move to
	var target_vector : Vector2 = Vector2(randi_range(-wander_range, wander_range), 0)
	owner.target_position += target_vector

func seek_player():
	if owner.short_vision.can_shoot_player():
		state_machine.transition_to("Attack")
		return
	if owner.long_vision.can_see_player():
		state_machine.transition_to("Chase")
		return

func accelerate_towards_point(point, delta):
	#Moving while wandering
	var direction = owner.global_position.direction_to(point).normalized()
	owner.velocity += direction * owner.movement_data.acceleration * delta
	owner.velocity = owner.velocity.limit_length(owner.movement_data.max_speed)
	
	#Look where moving
	owner.animator.flip_h = owner.velocity.x > 0

func start_timer():
	timer.wait_time = randi_range(1, 3)
	timer.start()

func _on_timer_timeout(): #Goes back to idle
	state_machine.transition_to("Idle")
