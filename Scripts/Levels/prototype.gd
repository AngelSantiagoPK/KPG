extends Node2D

#Data
const MOUSE : CompressedTexture2D = preload("res://Textures/UI/Mouse.png")
const MOUSE_OFFSET : Vector2 = Vector2(0, 0)

#Refrences
@onready var ui: PlayerUIContainer = $UI
var player: CharacterBody2D

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	EventManager.player_died.connect(player_died)
	EventManager.frame_freeze.connect(frame_freeze)
	player.active_camera(true)

func player_died():
	ui.layer = 1
	ui.main_menu.set_deferred("visible", true)
	DisplayServer.cursor_set_custom_image(MOUSE, DisplayServer.CURSOR_ARROW, MOUSE_OFFSET)

func _on_border_body_entered(body):
	body.die()

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
