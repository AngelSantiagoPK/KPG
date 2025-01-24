class_name PlayerUIContainer
extends CanvasLayer

@onready var chromatic_abberation: ColorRect = %ChromaticAbberation
@onready var main_menu: Button = %MainMenu


func _on_main_menu_button_up() -> void:
	AudioManager.play_sound(AudioManager.MENU_CLICK)
	get_tree().change_scene_to_file("res://Scenes/Levels/main_menu.tscn")

func _on_main_menu_mouse_entered() -> void:
	AudioManager.play_sound(AudioManager.MENU_HOVER)
