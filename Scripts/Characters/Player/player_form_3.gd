# Author: AngelSantiagoPK aka PKNinja
# Date: January 20, 2025
class_name Form_03
extends CharacterBody2D

# Variables
var bullets_amount : int = 50
@export var camera: Camera2D
@export var movement_data : MovementData
@export var stats : Stats
@export var fillament_data: FillamentData

@export var active: bool = false
var can_shoot: bool = true
var drone_ready: bool = true
var overheated: bool = false

# References
@onready var gun: Node2D = $Gun
@onready var barrel: Polygon2D = $Gun/Pivot/Barrel
@onready var tank_bullet_marker: Marker2D = $Gun/Pivot/Barrel/TankBulletMarker
@onready var drone_launch_marker: Marker2D = $Launcher/DroneLaunchMarker
@onready var gun_delay: Timer = $GunDelay
@onready var gun_cooldown: Timer = $GunCooldown
@onready var drone_cooldown: Timer = $DroneCooldown
@onready var camera_ref: String = get_tree().get_first_node_in_group("Camera").get_path()
@onready var status: Label = $Status
@onready var audio_streamEngine: AudioStreamPlayer2D = $AudioStreamPlayerEngine
@onready var audio_stream_sync: AudioStreamSynchronized = audio_streamEngine.stream as AudioStreamSynchronized


# Load Scenes
@onready var muzzle_load : PackedScene = preload("res://Scenes/Particles/muzzle.tscn")
@onready var bullet_load : PackedScene = preload("res://Scenes/Props/bullet.tscn")
@onready var death_particle_load : PackedScene = preload("res://Scenes/Particles/player_death_particle.tscn")
@onready var drone_load: PackedScene = preload("res://Scenes/Characters/drone.tscn")
@onready var remote: RemoteTransform2D = $RemoteTransform2D

func _ready():
	stats.health = stats.max_health
	
func _physics_process(delta):
	apply_gravity(delta)

	if not active:
		velocity.x = 0
		move_and_slide()
		return
	
	var input_vector = Input.get_axis("move_left","move_right")
	if input_vector != 0:
		apply_acceleration(input_vector, delta)
		# Increasing volume of tank move sfx layer
		audio_stream_sync.set_sync_stream_volume(0 ,-14)
	else:
		apply_friction(delta)
		# Lower the volume of the movement layer
		audio_stream_sync.set_sync_stream_volume(0, -80)  # Mute or reduce volume
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()

	if Input.is_action_pressed("shoot"):
		if bullets_amount > 0 and can_shoot and not overheated:
			can_shoot = false
			gun_delay.start()
			shoot()
		elif bullets_amount <= 0 and not overheated:
			overheat_message()
			gun_cooldown.start()
			overheated = true
	
	if Input.is_action_just_pressed("secondary_weapon"):
		if drone_ready:
			status.hide()
			drone_ready = false
			drone_cooldown.start()
			deploy_drone()
	
	move_and_slide()
	animate()

func apply_acceleration(input_vector, delta):
	velocity.x = move_toward(velocity.x, movement_data.max_speed * input_vector, movement_data.acceleration * delta)

func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += movement_data.gravity * movement_data.gravity_scale * delta

func knockback(vector):
	velocity = velocity.move_toward(vector * movement_data.knockback_force, movement_data.acceleration)

func jump():
	velocity.y = -movement_data.jump_strength
	AudioManager.play_sound(AudioManager.JUMP)

func animate():
	var mouse_position : Vector2 = (get_global_mouse_position() - global_position).normalized()
	gun.rotation = mouse_position.angle()
	if gun.scale.y == 1 and mouse_position.x < 0:
		gun.scale.y = -1
	elif gun.scale.y == -1 and mouse_position.x > 0:
		gun.scale.y = 1

func shoot() -> void:
	bullets_amount -= 1
	var mouse_position : Vector2 = (get_global_mouse_position() - global_position).normalized()
	var muzzle = muzzle_load.instantiate()
	var bullet = bullet_load.instantiate()
	tank_bullet_marker.add_child(muzzle)
	bullet.global_position = tank_bullet_marker.global_position
	bullet.target_vector = mouse_position
	bullet.rotation = mouse_position.angle()
	get_tree().current_scene.add_child(bullet)
	#Using Audio Manager
	AudioManager.play_random()
	#AudioManager.play_sound(AudioManager.SHOOT)
	

func deploy_drone() -> void:
	var drone = drone_load.instantiate()
	drone.global_position = drone_launch_marker.global_position
	get_tree().current_scene.add_child(drone)
	self.active = false
	drone.active = true
	self.check_for_active_camera()
	drone.check_for_active_camera()
	drone.drone_exit.connect(func (): back_to_tank(drone))
	drone.destroyed.connect(func (): back_to_tank(drone))

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

func back_to_tank(drone: Node) -> void:
	drone.active = false
	self.active = true
	drone.check_for_active_camera()
	self.check_for_active_camera()

func small_shake():
	if not camera:
		return
	camera.small_shake()

func die() -> void:
	AudioManager.play_sound(AudioManager.DEATH)
	var death_particle = death_particle_load.instantiate()
	death_particle.global_position = global_position
	get_tree().current_scene.add_child(death_particle)
	EventManager._form_destroyed.emit()

# Label Functions
func overheat_message() -> void:
	status.show()
	status.text = "overheated"

func drone_ready_message() -> void:
	status.show()
	status.text = "drone ready"

# Timer Functions
func _on_gun_delay_timeout() -> void:
	can_shoot = true

func _on_gun_cooldown_timeout() -> void:
	status.hide()
	bullets_amount = 99
	overheated = false

func _on_drone_cooldown_timeout() -> void:
	drone_ready = true
	drone_ready_message()
