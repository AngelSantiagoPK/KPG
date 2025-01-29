extends Control

#Refrences
@onready var bar : TextureProgressBar = $TextureProgressBar

func _ready():
	EventManager._decrease_health_bar.connect(decrement_health)
	EventManager._update_health_ui.connect(on_update_ui.bind())

func decrement_health():
	bar.value -= 1

func on_update_ui(stats: Stats) -> void:
	bar.max_value = stats.max_health
	bar.value = stats.health
