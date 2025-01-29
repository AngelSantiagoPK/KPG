extends Node

# Form Variables
var current_form: CharacterBody2D
var backup_form: CharacterBody2D

# Player Signals
signal _form_destroyed
signal _player_died
signal _spawn
signal _print_spawn(form: CharacterBody2D)

# UI Signals
signal _update_bullet_ui
signal _update_health_ui
signal _update_fillament_ui
signal _update_reserve_ammo_ui(count: int)

# Effect Signals
signal frame_freeze

#Data
var bullets_amount : int  = 30
var shells_amount : int = 30
var fillament_amount : int = 0
var last_printer: Printer

func use_fillament(amount: int):
	fillament_amount -= amount

func has_required_fillament(amount: int) -> bool:
	return amount <= fillament_amount

func set_current_form(form: CharacterBody2D) -> void:
	current_form = form

func get_current_form() -> CharacterBody2D:
	return current_form

func set_backup_form(form: CharacterBody2D) -> void:
	backup_form = form

func get_backup_form() -> CharacterBody2D:
	return backup_form
