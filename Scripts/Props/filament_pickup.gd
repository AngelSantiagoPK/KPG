extends Area2D

@export var value: int = 5
var score_alert: PackedScene = preload("res://Scenes/Components/score_alert.tscn")

func pickup_filament() -> void:
	AudioManager.play_sound(AudioManager.BULLET)
	EventManager.fillament_amount += value
	EventManager._update_fillament_ui.emit()
	drop_score_alert()
	queue_free()
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		pickup_filament() 

func drop_score_alert() -> void:
	var alert = score_alert.instantiate()
	alert.global_position = self.global_position
	alert.value = value
	get_tree().current_scene.call_deferred("add_child", alert)
