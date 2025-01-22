# Author: PKNinja
# Date: January 18, 2025
class_name Drone
extends CharacterBody2D

# Signals
signal destroyed
signal drone_exit

# Variables
@export var movement_data: MovementData
@export var stats: Stats
@export var energy: float = 100.0
@export var active: bool = false

# Constants
const EXPLOSION = preload("res://Scenes/Components/explosion_area.tscn")

# References
@onready var fly_animator: AnimationPlayer = %FlyAnimator
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var remote: RemoteTransform2D = $RemoteTransform2D
@onready var camera_ref: String = get_tree().get_first_node_in_group("Camera").get_path()

# Functions
func _ready() -> void:
	health_bar.value = energy
	health_bar.max_value = energy

func _physics_process(_delta: float) -> void:
	get_input()
	move_and_slide()

# Get input from thep player
func get_input():
	if not active:
		return
	
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if input_direction != Vector2.ZERO and energy > 0:
		energy -= 1
		velocity = velocity.move_toward(input_direction * movement_data.max_speed, movement_data.acceleration)
		health_bar.value = energy
	else:
		add_friction()
	
	if Input.is_action_just_pressed("shoot"):
		explode()
	
	if Input.is_action_just_pressed("interact"):
		drone_exit.emit()
		active = false
		

func add_friction() -> void:
	#TODO: Make the drone slow down when input direction is not being pressed to avoid sliding forever
	velocity = velocity.move_toward(Vector2.ZERO, movement_data.acceleration)

func explode() -> void:
	var explosion = EXPLOSION.instantiate()
	explosion.global_position = self.global_position
	get_tree().root.add_child(explosion)
	destroyed.emit()
	queue_free()

func active_camera(activation: bool) -> void:
	if activation:
		remote.remote_path = camera_ref
	else:
		remote.remote_path = ""

func _on_activation_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if not active:
			body.active = false
			active = true
