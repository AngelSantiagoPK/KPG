extends Area2D

@export var value: int = 5

func pickup_filament() -> void:
	AudioManager.play_sound(AudioManager.BULLET)
	EventManager.fillament_amount += value
	EventManager._update_fillament_ui.emit()
	queue_free()
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		pickup_filament() 
