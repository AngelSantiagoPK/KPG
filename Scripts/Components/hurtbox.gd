extends Area2D

func _on_area_entered(area):
	if owner.is_in_group("Bat"):
		if not area.is_in_group("Bat"):
			owner.stats.health -= area.damage
	else:
		owner.stats.health -= area.damage
	
	if owner.is_in_group("Player"):
		owner.knockback(area.knockback_vector)
	
	if owner.is_in_group("Tank"):
		#TODO: Affect the tank
		pass
	
	if owner.is_in_group("Drone"):
		#TODO: effect the drone when hit by things
		if area.is_in_group("Bar"):
			owner.stats.health -= area.damage
		pass
