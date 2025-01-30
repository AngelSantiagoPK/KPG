class_name Shell
extends Area2D

#Data
var speed : int = 420
var target_vector : Vector2
var destroyed : bool = false
var damage: int = 1

#Refrences
@onready var sprite : Sprite2D = $Sprite2D
@onready var particle : GPUParticles2D = $GPUParticles2D
@onready var no_collision_timer : Timer = $NoCollisionTimer
@onready var hitbox : Area2D = $Hitbox
@onready var hitbox_collision : CollisionShape2D = $Hitbox/CollisionShape2D

func _ready():
	hitbox.knockback_vector = target_vector #Updating the knockback vector
	no_collision_timer.start()

func _physics_process(delta):
	position += target_vector * speed * delta

func die():
	sprite.visible = false
	particle.emitting = true
	hitbox.set_deferred("monitorable", false)
	hitbox_collision.set_deferred("disabled", true)
	queue_free()

func _on_no_collision_timer_timeout():
	die()

func _on_body_entered(_body):
	die()
	if not destroyed:
		AudioManager.play_sound(AudioManager.BULLET)
		destroyed = true
