extends Node2D

onready var animsprite = $Sprite

func _ready():
	animsprite.play("anim")
	#$Sprite.rotation_degrees = rand_range(0, 360)
	#print($Sprite.rotation_degrees)


func _on_Sprite_animation_finished():
	queue_free()

