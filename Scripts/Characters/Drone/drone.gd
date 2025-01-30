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
@export var camera: Camera2D

# Constants
const EXPLOSION = preload("res://Scenes/Components/explosion_area.tscn")

# References
@onready var fly_animator: AnimationPlayer = %FlyAnimator
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var remote: RemoteTransform2D = $RemoteTransform2D
@onready var camera_ref: String = get_tree().get_first_node_in_group("Camera").get_path()
@onready var audio_stream_player_engine: AudioStreamPlayer2D = %AudioStreamPlayerEngine

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
		AudioManager.play_sound(AudioManager.EXPLOSION)
	
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

func check_for_active_camera() -> void:
	# Ensure get_tree() is valid (check if it exists)
	var tree = get_tree()
	if tree:
		# Only attempt to access the camera if tree is valid
		if active:
			var camera = tree.get_first_node_in_group("Camera")
			if camera:
				remote.remote_path = camera.get_path()
			else:
				remote.remote_path = ""  # No camera in the group
		else:
			remote.remote_path = ""  # If not active, clear the path
	else:
		# Handle the case where get_tree() is invalid
		print("Error: Scene tree is not available.")

func _on_activation_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if not active:
			body.active = false
			active = true
