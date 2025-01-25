extends Node

# Player Signals
signal _form_destroyed
signal _player_died

# UI Signals
signal _update_bullet_ui
signal _update_health_ui
signal _update_fillament_ui

# Effect Signals
signal frame_freeze

#Data
var bullets_amount : int  = 30
var shells_amount : int = 30
var fillament_amount : int = 0
var last_printer: Printer
var current_form: CharacterBody2D
var backup_form: CharacterBody2D

func _use_fillament(amount: int):
	fillament_amount -= amount


func destroy_current_form() -> void:
	current_form.active = false
	#current_form.check_for_active_camera()
	current_form.queue_free()

func build_new_form(form: CharacterBody2D) -> void:
	current_form = form
	current_form.active = true
	current_form.check_for_active_camera()

func swap_to_backup_form() -> void:
	last_printer.print_backup_form(backup_form.fillament_data.id)
	backup_form = null
	self._update_fillament_ui.emit()
