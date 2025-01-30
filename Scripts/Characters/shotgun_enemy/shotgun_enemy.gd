class_name ShotgunEnemy
extends CharacterBody2D

# Data
var shells_amount : int = 20
@export var movement_data: MovementData
@export var stats: Stats
@export var shot_size: int = 10
@export var shot_spread_in_deg: int = 30.0
var can_shoot: bool = false

# References
@onready var pistol_bullet_marker: Marker2D = $Hand/Pivot/Pistol/PistolBulletMarker
@onready var pivot: Node2D = $Hand/Pivot
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var health_bar_timer: Timer = $HealthBar/HealthBarTimer
var filament: PackedScene = preload("res://Scenes/Props/filament_pickup.tscn")

#Load Scenes
@onready var muzzle_load : PackedScene = preload("res://Scenes/Particles/muzzle.tscn")
@onready var shell_load : PackedScene = preload("res://Scenes/Props/enemy_shell.tscn")


func _ready():
	stats.health = stats.max_health
	health_bar.max_value = stats.max_health
	health_bar.value = stats.health

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	apply_friction(delta)
	move_and_slide()

func update_gun_direction(target_position: Vector2) -> Vector2:
	if target_position.x < pivot.global_position.x:
		pivot.scale.x = -1
		return Vector2.LEFT
	else:
		pivot.scale.x = 1
		return Vector2.RIGHT
	
func add_muzzle_flash() -> void:
	var muzzle = muzzle_load.instantiate()
	muzzle.global_position = pistol_bullet_marker.position
	pistol_bullet_marker.add_child(muzzle)

func shoot_shell():
	if not EventManager.has_current_form():
		return
	
	var target_position : Vector2 = EventManager.current_form.global_position
	var bullet_direction : Vector2 = update_gun_direction(target_position)
	await get_tree().create_timer(1.0).timeout
	add_muzzle_flash()
	
	for i in shot_size:
		var shell= shell_load.instantiate()
		var offset = (i - (shot_size / 2)) * (shot_spread_in_deg / shot_size)
		shell.global_position = pistol_bullet_marker.global_position
		shell.target_vector = bullet_direction.rotated(deg_to_rad(offset))
		get_tree().current_scene.add_child(shell)
	
	$AudioStreamPlayer2D.play()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += movement_data.gravity * movement_data.gravity_scale * delta

func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)

func knockback(vector):
	velocity = velocity.move_toward(vector * movement_data.knockback_force, movement_data.acceleration)

func update_health_bar():
	health_bar.value = stats.health
	health_bar.visible = true
	health_bar_timer.start()

func _on_shot_delay_timeout() -> void:
	shoot_shell()

func _on_health_bar_timer_timeout():
	health_bar.visible = false

func _on_hurtbox_area_entered(area):
	if not area.is_in_group("Enemy"):
		knockback(area.knockback_vector)
		self.update_health_bar()
		if stats.health <= 0:
			health_bar.visible = false
			drop()
			queue_free()

func drop() -> void:
	var drop = filament.instantiate()
	drop.global_position = owner.global_position
	drop.value = randi_range(1, 5)
	get_tree().current_scene.add_child(drop)
