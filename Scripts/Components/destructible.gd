class_name Destructible
extends Node

@export var health: int = 6
@onready var shard_particle_load : PackedScene = preload("res://Scenes/Particles/destructible_shards.tscn")

var destructible_shards

func _physics_process(delta: float) -> void:
	add_gravity(delta)

func add_gravity(delta: float) -> void:
	self.position.y += 9.8 * delta
	
func reduce_integrity(damage: int) -> void:
	health -= damage
	if health <= 0:
		create_shards()
		queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet"):
		self.reduce_integrity(2)
		area.queue_free()
	
	if area.is_in_group("Shell"):
		self.reduce_integrity(1)
		area.queue_free()

	if area.is_in_group("Explosion"):
		self.reduce_integrity(area.damage)
	
func create_shards() -> void:
	var shards = shard_particle_load.instantiate()
	shards.global_position = self.global_position
	get_tree().current_scene.add_child(shards)
