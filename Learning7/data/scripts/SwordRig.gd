extends RigidBody2D

func _on_PickupBox_area_entered(area):
	if area.get_parent().get_name() == "Player":
		queue_free()


func _rotate():
	$SwordSprite.flip_h = true
	$Hitbox/CollisionShape2D.position.x = -5.7
