extends Node2D

enum Types {
	Nothing =      0,
	Pistol =       1,
	Shotgun=       2,
	Machinegun=    3,
	Shouldergun=   4,
	Fireblaster=   5 
	}

@export var type = Types.Nothing
var data_list = []
var weapon_data : WeaponStats

func load_data():
	
	match type:
		0:
			weapon_data = load("res://Data/Enemy Weapon Data/Nothing_data.tres")
		1:
			weapon_data = load("res://Data/Enemy Weapon Data/Pistol_data.tres")
		2:
			weapon_data = load("res://Data/Enemy Weapon Data/Shotgun_data.tres")
		3:
			weapon_data = load("res://Data/Enemy Weapon Data/Machinegun_data.tres")
		4:
			weapon_data = load("res://Data/Enemy Weapon Data/Shouldergun_data.tres")
		5:
			weapon_data = load("res://Data/Enemy Weapon Data/Fireblaster_data.tres")
			
			
func _ready() -> void:
	load_data()
	$Label.text = weapon_data.debug_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
