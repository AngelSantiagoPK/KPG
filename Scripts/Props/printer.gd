class_name Printer
extends Area2D

var interactible: bool = false
var object: Node2D = null
var form_01_loaded: PackedScene = preload("res://Scenes/Characters/Form_01.tscn")
var form_02_loaded: PackedScene = preload("res://Scenes/Characters/Form_02.tscn")
var form_03_loaded: PackedScene = preload("res://Scenes/Characters/Form_03.tscn")
@onready var ui_container: VBoxContainer = $"UI Container"
@onready var backup_container: VBoxContainer = $BackupContainer
@onready var printer_spawn_marker: Marker2D = $PrinterSpawnMarker

func _physics_process(_delta: float) -> void:
	ui_container.set_visible(interactible)
	backup_container.set_visible(interactible)
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		interactible = true
		object = body
		EventManager.last_printer = self

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
			form = form_01_loaded.instantiate()
		2:
			form = form_02_loaded.instantiate()
		3:
			form = form_03_loaded.instantiate()
	
	form.global_position = printer_spawn_marker.global_position
	get_tree().root.add_child(form)
	if EventManager.current_form:
		EventManager.current_form.queue_free()
	EventManager.build_new_form(form)
	form.check_for_active_camera()

func queue_backup_form(form_number: int) -> void:
	if not form_number is int:
		return
	
	var form
	match form_number:
		1:
			form = form_01_loaded.instantiate()
		2:
			form = form_02_loaded.instantiate()
		3:
			form = form_03_loaded.instantiate()
	
	EventManager.backup_form = form

func print_backup_form(form_number: int) -> void:
	if not form_number is int:
		return
	
	var form
	match form_number:
		1:
			form = form_01_loaded.instantiate()
		2:
			form = form_02_loaded.instantiate()
		3:
			form = form_03_loaded.instantiate()
	
	form.global_position = EventManager.current_form.global_position
	EventManager.destroy_current_form()
	get_tree().current_scene.call_deferred("add_child", form)
	EventManager.build_new_form(form)
	

func paid_fillament(cost: int) -> bool:
	if EventManager.fillament_amount < cost:
		return false

	AudioManager.play_sound(AudioManager.MENU_CLICK)
	EventManager._use_fillament(cost)
	EventManager._update_fillament_ui.emit()
	return true


# Form Button Functions
func _on_form_01_pressed() -> void:
	const FORM_DATA = preload("res://Data/Fillament Data/Form_01_Fillament_Data.tres")
	var cost = FORM_DATA.cost
	if paid_fillament(cost) == true:
		print_form(1)
	
func _on_form_02_pressed() -> void:
	const FORM_DATA = preload("res://Data/Fillament Data/Form_02_Fillament_Data.tres")
	var cost = FORM_DATA.cost
	if paid_fillament(cost) == true:
		print_form(2)

func _on_form_03_pressed() -> void:
	const FORM_DATA = preload("res://Data/Fillament Data/Form_03_Fillament_Data.tres")
	var cost = FORM_DATA.cost
	if paid_fillament(cost) == true:
		print_form(3)

# Backup Form Buttons Functions
func _on_form_01_backup_button_up() -> void:
	queue_backup_form(1)

func _on_form_02_backup_button_up() -> void:
	queue_backup_form(2)

func _on_form_03_backup_button_up() -> void:
	queue_backup_form(3)
