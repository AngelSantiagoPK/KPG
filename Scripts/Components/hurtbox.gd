extends Area2D

func _on_area_entered(area):
	if owner.is_in_group("Player"):
		owner.knockback(area.knockback_vector)
		owner.stats.health -= area.damage
		return
	
	if owner.is_in_group("Drone"):
		if area.is_in_group("Enemy"):
			owner.stats.health -= area.damage
			return

	if owner.is_in_group("Enemy"):
		if area.is_in_group("Enemy"):
			return
		if area.is_in_group("EnemyShell"):
			return
		owner.stats.health -= area.damage
		return
