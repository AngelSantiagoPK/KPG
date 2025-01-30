class_name TutorialLevel
extends Node2D

#Data
const MOUSE : CompressedTexture2D = preload("res://Textures/UI/Mouse.png")
const MOUSE_OFFSET : Vector2 = Vector2(0, 0)

# References
@export var ui: PlayerUIContainer
@onready var win_condition: Node2D = $WinCondition

# Functions
func _ready() -> void:
	EventManager._spawn.emit()
	EventManager._player_died.connect(player_died)
	EventManager.frame_freeze.connect(frame_freeze)
	win_condition.level_clear.connect(on_win)

func player_died():
	EventManager.current_form.queue_free()
	ui.layer = 1
	ui.main_menu.set_deferred("visible", true)
	DisplayServer.cursor_set_custom_image(MOUSE, DisplayServer.CURSOR_ARROW, MOUSE_OFFSET)

func frame_freeze():
	var time_scale_value : float = 0.1
	var duration : float = 0.4
	ui.chromatic_abberation.visible = true
	Engine.time_scale = time_scale_value
	await get_tree().create_timer(duration * time_scale_value).timeout
	ui.chromatic_abberation.visible = false
	Engine.time_scale = 1.0

func _unhandled_input(_event):
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://Scenes/Levels/main_menu.tscn")

func on_win() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/credits.tscn")
	pass
