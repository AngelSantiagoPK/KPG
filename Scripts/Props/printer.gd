class_name Printer
extends Area2D

var interactible: bool = false
var object: Node2D = null
var form_01_loaded: PackedScene = preload("res://Scenes/Characters/player.tscn")
var form_02_loaded: PackedScene = preload("res://Scenes/Characters/player.tscn")
var form_03_loaded: PackedScene = preload("res://Scenes/Characters/player_tank.tscn")
@onready var ui_container: VBoxContainer = $"UI Container"
@onready var printer_spawn_marker: Marker2D = $PrinterSpawnMarker

func _physics_process(_delta: float) -> void:
	ui_container.set_visible(interactible)
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		interactible = true
		object = body

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		interactible = false
		object = null

func print_form(form_number: int) -> void:
	if not form_number is int:
		return

	var form
	match form_number:
		1:
			#TODO: Add form_01
			pass
		2:
			form = form_02_loaded.instantiate()
		3:
			form = form_03_loaded.instantiate()
	
	form.global_position = printer_spawn_marker.global_position
	get_tree().current_scene.add_child(form)
	form.active_camera(true)
	object.active_camera(false)
	object.queue_free()

func _on_form_01_pressed() -> void:
	pass # Replace with function body.
	
func _on_form_02_pressed() -> void:
	print_form(2)

func _on_form_03_pressed() -> void:
	print_form(3)
