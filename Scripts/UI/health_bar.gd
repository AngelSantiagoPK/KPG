extends Control

#Refrences
@onready var bar : TextureProgressBar = $TextureProgressBar
@onready var label: Label = $Label

func _ready():
	EventManager._decrease_health_bar.connect(decrement_health)
	EventManager._update_health_ui.connect(on_update_ui.bind())

func decrement_health():
	var tween = create_tween()
	var new_value: int = bar.value - 1
	tween.tween_property(self.bar, "value", new_value, 1.0)


func on_update_ui(stats: Stats) -> void:
	bar.max_value = stats.max_health
	bar.value = stats.health
