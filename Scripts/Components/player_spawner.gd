class_name PlayerSpawner
extends Node2D

@onready var spawn_marker: Marker2D = $SpawnMarker
const FORM_01 = preload("res://Scenes/Characters/Form_01.tscn")
const FORM_02 = preload("res://Scenes/Characters/Form_02.tscn")
const FORM_03 = preload("res://Scenes/Characters/Form_03.tscn")

func _ready() -> void:
	EventManager._form_destroyed.connect(respawn_player)
	EventManager._spawn.connect(spawn_player)
	EventManager._print_spawn.connect(print_spawn_player.bind())

func update_spawn_position(position: Vector2) -> void:
	spawn_marker.global_position = position

func spawn_player() -> void:
	var curr_form = EventManager.get_current_form()
	if curr_form != null:
		spawn_marker.global_position = curr_form.global_position
		curr_form.queue_free()
	
	var form = FORM_02.instantiate()
	EventManager.set_current_form(form)
	form.global_position = spawn_marker.global_position
	form.active = true
	add_child(form)
	form.check_for_active_camera()

func respawn_player() -> void:
	if not has_backup():
		EventManager._player_died.emit()
		return
	
	var cost = EventManager.backup_form.fillament_data.cost
	if not EventManager.has_required_fillament(cost):
		EventManager._player_died.emit()
		return
	
	EventManager.use_fillament(cost)
	var form = EventManager.get_backup_form()
	update_spawn_position(EventManager.get_current_form().global_position)
	EventManager.get_current_form().queue_free()
	EventManager.set_current_form(form)
	form.global_position = spawn_marker.global_position
	form.active = true
	self.call_deferred("add_child", form)
	EventManager.set_backup_form(null)
	form.check_for_active_camera()

func print_spawn_player(form: CharacterBody2D) -> void:
	update_spawn_position(EventManager.get_current_form().global_position)
	EventManager.get_current_form().queue_free()
	EventManager.set_current_form(form)
	form.global_position = spawn_marker.global_position
	form.active = true
	add_child(form)
	form.check_for_active_camera()

func has_backup(): return EventManager.backup_form != null

func pay_for_respawn(cost: int) -> void:
	AudioManager.play_sound(AudioManager.MENU_CLICK)
	EventManager.use_fillament(cost)
	EventManager._update_fillament_ui.emit()
