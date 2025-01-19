# Author: AngelSantiagoPK aka PKNinja
# Date: January 18, 2025
class_name ExplosionArea
extends Area2D

@export var damage: int = 10
var knockback_vector: Vector2 = self.global_position

# REFERENCES
@onready var explosion_particles: CPUParticles2D = %ExplosionParticles

func _ready() -> void:
	explode()

func explode() -> void:
	explosion_particles.restart()
	explosion_particles.emitting = true
	await explosion_particles.finished
	queue_free()
