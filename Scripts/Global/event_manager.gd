extends Node

# Player Signals
signal form_destroyed
signal player_died

# UI Signals
signal update_bullet_ui
signal update_health_ui
signal update_fillament_ui

# Effect Signals
signal frame_freeze

#Data
var bullets_amount : int
var shells_amount : int
var fillament_amount : int
var last_printer: Printer
var current_form: CharacterBody2D
