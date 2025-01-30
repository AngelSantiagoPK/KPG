extends Area2D

#Data
var player = null

#Variables
@onready var collision: CollisionShape2D = $CollisionShape2D

func can_see_player():
	return player != null

func _physics_process(_delta: float) -> void:
	if owner.short_vision.player:
		player = null
		return

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body



func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = null
