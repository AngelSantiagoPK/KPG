extends State

#Data
var target_range : int = 4
var target_position: Vector2
var shooting: bool = true

#Refrences
@onready var timer: Timer = $Timer
@onready var gun_delay: Timer = $GunDelay
@onready var muzzle_load : PackedScene = preload("res://Scenes/Particles/muzzle.tscn")
@onready var bullet_load : PackedScene = preload("res://Scenes/Props/bullet.tscn")

func enter(_msg := {}):
	owner.label.text = "Attack"
	start_timer()

func physics_update(delta: float) -> void:
	seek_player()
	apply_friction(delta)
	if shooting:
		shooting = false
		gun_delay.start()
		shoot()
	owner.add_gravity(delta)

func shoot():
	owner.shoot()

func start_timer():
	timer.wait_time = randi_range(1, 2)
	timer.start()

func seek_player():
	if not owner.short_vision.can_shoot_player():
		state_machine.transition_to("Idle")
		return

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
	if owner.short_vision.player != null:
		target_position = owner.short_vision.player.global_position
		shooting = true

func _on_gun_delay_timeout() -> void:
	shooting = true
