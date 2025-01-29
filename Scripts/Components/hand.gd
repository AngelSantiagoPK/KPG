class_name Hand
extends Node2D

# Variables
var bullets: int = 0
var reserve: int = 0

# Static Gun Types
enum GUN_TYPE {
	PISTOL,
	RIFLE,
	SHOTGUN,
	CANNON
}
@export var current_type: GUN_TYPE = GUN_TYPE.PISTOL
var data: GunData
var can_shoot: bool = true

# References
@onready var pistol_bullet_marker: Marker2D = $Pivot/Pistol/PistolBulletMarker
@onready var gun_delay: Timer = $GunDelay
@onready var gun_reload: Timer = $GunReload

#Load Scenes
@onready var muzzle_load : PackedScene = preload("res://Scenes/Particles/muzzle.tscn")
@onready var bullet_load : PackedScene = preload("res://Scenes/Props/bullet.tscn")
@onready var shell_load : PackedScene = preload("res://Scenes/Props/shell.tscn")

func _ready() -> void:
	match current_type:
		GUN_TYPE.PISTOL:
			data = preload("res://Data/GunData/Pistol_Data.tres")
		GUN_TYPE.RIFLE:
			data = preload("res://Data/GunData/Rifle_Data.tres")
		GUN_TYPE.SHOTGUN:
			data = preload("res://Data/GunData/Shotgun_Data.tres")
		GUN_TYPE.CANNON:
			data = preload("res://Data/GunData/Cannon_Data.tres")
	
	if data == null:
		return
	
	self.bullets = data.mag_size
	self.reserve = data.reserve_ammo
	self.gun_delay.wait_time = data.gun_delay
	self.gun_reload.wait_time = data.reload_delay
	EventManager._update_bullet_ui.emit(bullets)
	EventManager._update_reserve_ammo_ui.emit(reserve)


func _physics_process(delta: float) -> void:
	match current_type:
		GUN_TYPE.PISTOL:
			if Input.is_action_just_pressed("shoot"):
				if bullets > 0:
					use_weapon()
		GUN_TYPE.SHOTGUN:
			if Input.is_action_just_pressed("shoot"):
				if bullets > 0:
					use_weapon()
		GUN_TYPE.RIFLE:
			if Input.is_action_pressed("shoot"):
				if bullets > 0:
					use_weapon()
		GUN_TYPE.CANNON:
			if Input.is_action_pressed("shoot"):
				if bullets > 0:
					use_weapon()
	
	if Input.is_action_just_pressed("interact"):
		reload()
	
func use_weapon() -> void:
	if not can_shoot:
		return
	can_shoot = false
	gun_delay.start()
	
	if current_type == GUN_TYPE.SHOTGUN:
		shoot_shell()
	else:
		shoot()

func shoot():
	bullets -= 1
	EventManager.bullets_amount -= 1
	EventManager._update_bullet_ui.emit(bullets)
	var mouse_position : Vector2 = (get_global_mouse_position() - global_position).normalized()
	var muzzle = muzzle_load.instantiate()
	var bullet = bullet_load.instantiate()
	pistol_bullet_marker.add_child(muzzle)
	bullet.global_position = pistol_bullet_marker.global_position
	bullet.target_vector = mouse_position
	bullet.rotation = mouse_position.angle()
	get_tree().current_scene.add_child(bullet)
	#Using Audio Manager
	AudioManager.play_sound(AudioManager.SHOOT)

func shoot_shell():
	bullets -= 1
	EventManager._update_bullet_ui.emit(bullets)
	var mouse_position : Vector2 = (get_global_mouse_position() - global_position).normalized()
	var muzzle = muzzle_load.instantiate()
	muzzle.global_position = pistol_bullet_marker.global_position
	pistol_bullet_marker.add_child(muzzle)
	
	var shells: Array[Shell] = []
	for i in data.shot_size:
		var shell: Shell = shell_load.instantiate()
		var offset = (i - (data.mag_size / 2)) * (data.shot_spread / data.mag_size)
		shell.global_position = pistol_bullet_marker.global_position
		shell.target_vector = mouse_position.rotated(deg_to_rad(offset))
		shells.append(shell)
	
	for i in shells:
		get_tree().current_scene.add_child(i)
	#Using Audio Manager
	AudioManager.play_sound(AudioManager.SHOOT)

func reload() -> void:
	if reserve <= 0:
		return
	
	#Using Audio Manager
	AudioManager.play_sound(AudioManager.SHOOT)
	gun_reload.start()


func _on_gun_delay_timeout() -> void:
	can_shoot = true

func _on_gun_reload_timeout() -> void:
	var new_clip: int = 0
	var bullets_needed: int = data.mag_size - bullets
	if reserve >= bullets_needed:
		reserve -= bullets_needed
		new_clip = data.mag_size
	else:
		new_clip = reserve
		reserve = 0
	
	bullets = new_clip
	EventManager._update_bullet_ui.emit(bullets)
	EventManager._update_reserve_ammo_ui.emit(reserve)
	#Using Audio Manager
	AudioManager.play_sound(AudioManager.SHOOT)
