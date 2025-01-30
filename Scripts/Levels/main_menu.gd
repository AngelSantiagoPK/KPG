extends Control

#Data
const CROSSHAIR : CompressedTexture2D = preload("res://Textures/UI/Crosshair.png")
const MOUSE : CompressedTexture2D = preload("res://Textures/UI/Mouse.png")
const CROSSHAIR_OFFSET : Vector2 = Vector2(12, 12)
const MOUSE_OFFSET : Vector2 = Vector2(0, 0)


func _ready():
	DisplayServer.cursor_set_custom_image(MOUSE, DisplayServer.CURSOR_ARROW, MOUSE_OFFSET)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_start_mouse_entered():
	AudioManager.play_sound(AudioManager.MENU_HOVER)

func _on_quit_mouse_entered():
	AudioManager.play_sound(AudioManager.MENU_HOVER)

func _on_start_button_up():
	AudioManager.play_sound(AudioManager.MENU_CLICK)
	DisplayServer.cursor_set_custom_image(CROSSHAIR, DisplayServer.CURSOR_ARROW, CROSSHAIR_OFFSET)
	get_tree().change_scene_to_file("res://Scenes/Levels/main_level_test1.tscn")

func _on_quit_button_up():
	AudioManager.play_sound(AudioManager.MENU_CLICK)
	get_tree().quit()
