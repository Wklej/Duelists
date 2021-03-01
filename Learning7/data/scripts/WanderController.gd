extends Node2D

export(int) var wander_range = 32

onready var starting_position = global_position #const?
onready var target_position = global_position
var sPosition = 2

func _ready():
	update_target_position()

func update_target_position():
	var target_vector = Vector2(rand_range(-wander_range, wander_range), 0)
	target_position = starting_position + target_vector
	#target_position = target_vector

func get_time_left():
	return $Timer.time_left

func start_wander_timer(duration):
	$Timer.start(duration)

func _on_Timer_timeout():
	update_target_position()

func _start_Ctimer(duration):
	$Cooldown.start(duration)


func get_CooldownTime_left():
	return $Cooldown.time_left


func _on_Cooldown_timeout():
	sPosition = round(rand_range(0, 2))
	#print(sPosition)
