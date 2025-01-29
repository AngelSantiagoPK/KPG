extends Label

func _ready() -> void:
	EventManager._update_reserve_ammo_ui.connect(update_text.bind())

func update_text(count: int) -> void:
	self.text = str(count)
